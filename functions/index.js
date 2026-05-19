/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
// const {onRequest} = require("firebase-functions/https");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const {getDataConnectClient} = require("firebase-data-connect");
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const client = getDataConnectClient();

  try {
    // Insert user into SQL database
    const userMutation = `
      mutation AddUser($data: UserInsertInput!) {
        insertUser(data: $data) {
          id
          displayName
          email
          role
        }
      }
    `;

    await client.mutate(userMutation, {
      data: {
        id: user.uid,
        authId: user.uid,
        role: "client",
        email: user.email,
        displayName: user.displayName || "New User",
        createdAt: new Date().toISOString(),
      },
    });

    console.log("User inserted into SQL:", user.uid);

    // Create trial subscription for new users
    const subscriptionMutation = `
      mutation CreateSubscription($data: SubscriptionInsertInput!) {
        insertSubscription(data: $data) {
          id
          userId
          plan
          status
          startDate
          endDate
        }
      }
    `;

    const trialEndDate = new Date();
    trialEndDate.setMonth(trialEndDate.getMonth() + 2); // 2 months trial

    await client.mutate(subscriptionMutation, {
      data: {
        id: `sub_${user.uid}_${Date.now()}`,
        userId: user.uid,
        plan: "trial",
        status: "active",
        startDate: new Date().toISOString(),
        endDate: trialEndDate.toISOString(),
        price: 0,
        currency: "TZS",
        autoRenew: true,
      },
    });

    console.log("Trial subscription created for user:", user.uid);
  } catch (error) {
    console.error("Error creating user in SQL:", error);
    throw error;
  }
});

// Automated booking creation
exports.onBookingCreated = functions.firestore
    .document("bookings/{bookingId}")
    .onCreate(async (snap, context) => {
      const booking = snap.data();
      const bookingId = context.params.bookingId;

      try {
        const client = getDataConnectClient();

        const mutation = `
      mutation AddBooking($data: BookingInsertInput!) {
        insertBooking(data: $data) {
          id
          clientId
          proId
          status
          price
        }
      }
    `;

        await client.mutate(mutation, {
          data: {
            id: bookingId,
            clientId: booking.clientId,
            proId: booking.proId,
            serviceId: booking.serviceId,
            status: booking.status || "pending",
            bookingDate: booking.bookingDate,
            duration: booking.duration || 60,
            price: booking.price,
            currency: booking.currency || "TZS",
            notes: booking.notes,
            createdAt: new Date().toISOString(),
          },
        });

        console.log("Booking inserted into SQL:", bookingId);
      } catch (error) {
        console.error("Error creating booking in SQL:", error);
        throw error;
      }
    });

// Automated review creation
exports.onReviewCreated = functions.firestore
    .document("reviews/{reviewId}")
    .onCreate(async (snap, context) => {
      const review = snap.data();
      const reviewId = context.params.reviewId;

      try {
        const client = getDataConnectClient();

        const mutation = `
      mutation AddReview($data: ReviewInsertInput!) {
        insertReview(data: $data) {
          id
          bookingId
          rating
          comment
        }
      }
    `;

        await client.mutate(mutation, {
          data: {
            id: reviewId,
            bookingId: review.bookingId,
            clientId: review.clientId,
            proId: review.proId,
            rating: review.rating,
            comment: review.comment,
            createdAt: new Date().toISOString(),
          },
        });

        console.log("Review inserted into SQL:", reviewId);
      } catch (error) {
        console.error("Error creating review in SQL:", error);
        throw error;
      }
    });

// Subscription expiry check (runs daily)
exports.checkSubscriptionExpiry = functions.pubsub
    .schedule("0 0 * * *")
    .onRun(async (context) => {
      try {
        const client = getDataConnectClient();

        const query = `
      query GetExpiringSubscriptions {
        subscriptions(where: {
          endDate: { lte: $today }
          status: { eq: "active" }
        }) {
          id
          userId
          endDate
        }
      }
    `;

        const today = new Date().toISOString();
        const result = await client.query(query, {today});

        for (const subscription of result.subscriptions) {
          // Update subscription status to expired
          const updateMutation = `
        mutation UpdateSubscriptionStatus($id: ID!, $status: String!) {
          updateSubscription(where: { id: $id }, data: { status: $status }) {
            id
            status
          }
        }
      `;

          await client.mutate(updateMutation, {
            id: subscription.id,
            status: "expired",
          });

          console.log("Subscription expired:", subscription.id);

          // Start 3-day grace period
          const graceEndDate = new Date();
          graceEndDate.setDate(graceEndDate.getDate() + 3);

          const graceMutation = `
        mutation StartGracePeriod($id: ID!, $endDate: String!) {
          updateSubscription(where: { id: $id }, data: { 
            status: "grace_period",
            endDate: $endDate
          }) {
            id
            status
            endDate
          }
        }
      `;

          await client.mutate(graceMutation, {
            id: subscription.id,
            endDate: graceEndDate.toISOString(),
          });

          console.log("Grace period started for:", subscription.id);
        }
      } catch (error) {
        console.error("Error checking subscription expiry:", error);
        throw error;
      }
    });
