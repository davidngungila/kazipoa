
class ProfessionalModel {
  final String id;
  final String name;
  final String service;
  final String category;
  final double rating;
  final int completedJobs;
  final String price;
  final String priceUnit;
  final String badge;
  final String profilePhoto;
  final String bio;
  final String location;
  final List<String> skills;
  final bool isOnline;
  final String? phoneNumber;
  final String? email;

  ProfessionalModel({
    required this.id,
    required this.name,
    required this.service,
    required this.category,
    required this.rating,
    required this.completedJobs,
    required this.price,
    required this.priceUnit,
    required this.badge,
    required this.profilePhoto,
    required this.bio,
    required this.location,
    required this.skills,
    this.isOnline = false,
    this.phoneNumber,
    this.email,
  });
}

class ProfessionalsData {
  static List<ProfessionalModel> getAllProfessionals() {
    return [
      // Plumbing Professionals
      ProfessionalModel(
        id: 'pro_001',
        name: 'Bakari Said',
        service: 'Mtaalamu wa Mabomba',
        category: 'Bomba',
        rating: 4.9,
        completedJobs: 127,
        price: '25,000',
        priceUnit: '/saa',
        badge: 'Platinum',
        profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        bio: 'Mtaalamu wa mabomba wenye uzoefu wa miaka 10 katika usakinishaji na matengenezo ya mifumo ya maji na mabomba.',
        location: 'Dar es Salaam, Tanzania',
        skills: ['Usakinishaji Mabomba', 'Matengenezo', 'Mabomba ya Maji', 'Mabomba ya Ndani'],
        isOnline: true,
        phoneNumber: '+255 712 345 678',
        email: 'bakari.said@kazipoa.co.tz',
      ),
      
      ProfessionalModel(
        id: 'pro_002',
        name: 'Hassan Juma',
        service: 'Mtaalamu wa Mabomba',
        category: 'Bomba',
        rating: 4.7,
        completedJobs: 89,
        price: '22,000',
        priceUnit: '/saa',
        badge: 'Gold',
        profilePhoto: 'https://images.unsplash.com/photo-1472099645785-f5e65b8f8b6b?w=150&h=150&fit=crop&crop=face',
        bio: 'Mfundi wa mabomba mwenye sifa katika matengenezo ya dharura na usakinishaji wa miradi mipya.',
        location: 'Mwanza, Tanzania',
        skills: ['Matengenezo ya Dharura', 'Usakinishaji', 'Mabomba ya Gesi', 'Pampu'],
        isOnline: false,
        phoneNumber: '+255 754 234 567',
        email: 'hassan.juma@kazipoa.co.tz',
      ),

      // Electrical Professionals
      ProfessionalModel(
        id: 'pro_003',
        name: 'John Michael',
        service: 'Mtaalamu wa Umeme',
        category: 'Umeme',
        rating: 4.8,
        completedJobs: 156,
        price: '30,000',
        priceUnit: '/saa',
        badge: 'Platinum',
        profilePhoto: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        bio: 'Mhandisi wa umeme mwenye leseni na uzoefu wa kufanya kazi kwenye miradi ya makampuni na ya nyumba.',
        location: 'Arusha, Tanzania',
        skills: ['Usakinishaji Umeme', 'Mabodi ya Umeme', 'Umeme wa Jua', 'Matengenezo'],
        isOnline: true,
        phoneNumber: '+255 713 456 789',
        email: 'john.michael@kazipoa.co.tz',
      ),

      ProfessionalModel(
        id: 'pro_004',
        name: 'Grace Mwangi',
        service: 'Mtaalamu wa Umeme',
        category: 'Umeme',
        rating: 4.6,
        completedJobs: 73,
        price: '28,000',
        priceUnit: '/saa',
        badge: 'Silver',
        profilePhoto: 'https://images.unsplash.com/photo-1494790108755-2616b332c0ca?w=150&h=150&fit=crop&crop=face',
        bio: 'Mhandisi wa umeme mwanamke mwenye weledi katika usakinishaji wa mfumo wa umeme wa kibiashara.',
        location: 'Dodoma, Tanzania',
        skills: ['Umeme wa Kibiashara', 'Mabodi', 'Usakinishaji', 'Matengenezo'],
        isOnline: true,
        phoneNumber: '+255 765 890 123',
        email: 'grace.mwangi@kazipoa.co.tz',
      ),

      // Cleaning Professionals
      ProfessionalModel(
        id: 'pro_005',
        name: 'Aisha Hassan',
        service: 'Mtaalamu wa Usafi',
        category: 'Usafi',
        rating: 4.8,
        completedJobs: 203,
        price: '20,000',
        priceUnit: '/saa',
        badge: 'Gold',
        profilePhoto: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        bio: 'Mtaalamu wa usafi wa nyumba na ofisi zenye vifaa vya kisasa na mbinu bora za usafi.',
        location: 'Dar es Salaam, Tanzania',
        skills: ['Usafi wa Nyumba', 'Usafi wa Ofisi', 'Usafi wa Kina', 'Vifaa vya Kisasa'],
        isOnline: false,
        phoneNumber: '+255 714 567 890',
        email: 'aisha.hassan@kazipoa.co.tz',
      ),

      ProfessionalModel(
        id: 'pro_006',
        name: 'Fatuma Kimario',
        service: 'Mtaalamu wa Usafi',
        category: 'Usafi',
        rating: 4.5,
        completedJobs: 94,
        price: '18,000',
        priceUnit: '/saa',
        badge: 'Silver',
        profilePhoto: 'https://images.unsplash.com/photo-1544005173-66dd017e4c0c?w=150&h=150&fit=crop&crop=face',
        bio: 'Mtaalamu wa usafi mwenye uzoefu katika usafi wa maeneo makubwa na miradi ya kibiashara.',
        location: 'Mbeya, Tanzania',
        skills: ['Usafi wa Maeneo Makubwa', 'Usafi wa Viwanda', 'Usafi wa Ghorofa', 'Vifaa'],
        isOnline: true,
        phoneNumber: '+255 756 345 234',
        email: 'fatuma.kimario@kazipoa.co.tz',
      ),

      // Construction Professionals
      ProfessionalModel(
        id: 'pro_007',
        name: 'Joseph Mwangi',
        service: 'Mtaalamu wa Ujenzi',
        category: 'Ujenzi',
        rating: 4.7,
        completedJobs: 45,
        price: '35,000',
        priceUnit: '/saa',
        badge: 'Gold',
        profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        bio: 'Mjenzi mwenye leseni na uzoefu wa kujenga nyumba za kisasa na miradi ya kibiashara.',
        location: 'Tanga, Tanzania',
        skills: ['Ujenzi wa Nyumba', 'Ukarabati', 'Uchoraji', 'Mipango ya Ujenzi'],
        isOnline: true,
        phoneNumber: '+255 712 789 456',
        email: 'joseph.mwangi@kazipoa.co.tz',
      ),

      ProfessionalModel(
        id: 'pro_008',
        name: 'Mary Kessy',
        service: 'Mtaalamu wa Ujenzi',
        category: 'Ujenzi',
        rating: 4.4,
        completedJobs: 28,
        price: '32,000',
        priceUnit: '/saa',
        badge: 'Bronze',
        profilePhoto: 'https://images.unsplash.com/photo-1489424732224-3da51c26a811?w=150&h=150&fit=crop&crop=face',
        bio: 'Mjenzi mwanamke mwenye weledi katika ujenzi wa nyumba ndogo na miradi ya ukarabati.',
        location: 'Kilimanjaro, Tanzania',
        skills: ['Ukarabati wa Ndani', 'Uchoraji', 'Ujenzi wa Kiasa', 'Rangi na Vipodo'],
        isOnline: false,
        phoneNumber: '+255 723 456 789',
        email: 'mary.kessy@kazipoa.co.tz',
      ),

      // Automotive Professionals
      ProfessionalModel(
        id: 'pro_009',
        name: 'David Mcharo',
        service: 'Mtaalamu wa Gari',
        category: 'Gari',
        rating: 4.9,
        completedJobs: 312,
        price: '25,000',
        priceUnit: '/saa',
        badge: 'Platinum',
        profilePhoto: 'https://images.unsplash.com/photo-1507591064342-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
        bio: 'Mekanika mwenye uzoefu wa miaka 15 katika matengenezo ya aina zote za magari.',
        location: 'Dar es Salaam, Tanzania',
        skills: ['Matengenezo ya Magari', 'Mafuta ya Mafuta', 'Mabadiliko ya Mafuta', 'Diagnostics'],
        isOnline: true,
        phoneNumber: '+255 715 234 567',
        email: 'david.mcharo@kazipoa.co.tz',
      ),

      ProfessionalModel(
        id: 'pro_010',
        name: 'Ali Ramadhan',
        service: 'Mtaalamu wa Gari',
        category: 'Gari',
        rating: 4.6,
        completedJobs: 187,
        price: '22,000',
        priceUnit: '/saa',
        badge: 'Silver',
        profilePhoto: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150&h=150&fit=crop&crop=face',
        bio: 'Mekanika mtaalamu wa magari ya kisasa na vifaa vya elektroniki.',
        location: 'Mwanza, Tanzania',
        skills: ['Diagnostics za Elektroniki', 'Matengenezo ya Magari ya Kisasa', 'AC', 'Mifereji'],
        isOnline: false,
        phoneNumber: '+255 767 890 123',
        email: 'ali.ramadhan@kazipoa.co.tz',
      ),

      // Beauty Professionals
      ProfessionalModel(
        id: 'pro_011',
        name: 'Grace Mrema',
        service: 'Mtaalamu wa Mapambo',
        category: 'Mapambo',
        rating: 4.8,
        completedJobs: 267,
        price: '15,000',
        priceUnit: '/saa',
        badge: 'Gold',
        profilePhoto: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        bio: 'Mtaalamu wa mapambo na urembo mwenye uzoefu wa miaka 8 katika tasnia ya kisasa.',
        location: 'Dar es Salaam, Tanzania',
        skills: ['Urembo wa uso', 'Kukata nywele', 'Masaji', 'Manicure & Pedicure'],
        isOnline: true,
        phoneNumber: '+255 713 456 234',
        email: 'grace.mrema@kazipoa.co.tz',
      ),

      ProfessionalModel(
        id: 'pro_012',
        name: 'Sophia Mbeki',
        service: 'Mtaalamu wa Mapambo',
        category: 'Mapambo',
        rating: 4.5,
        completedJobs: 134,
        price: '18,000',
        priceUnit: '/saa',
        badge: 'Silver',
        profilePhoto: 'https://images.unsplash.com/photo-1489424732224-3da51c26a811?w=150&h=150&fit=crop&crop=face',
        bio: 'Mtaalamu wa mapambo mwenye weledi katika matumizi ya bidhaa za hali ya juu.',
        location: 'Zanzibar, Tanzania',
        skills: ['Makeup ya Matukio', 'Mapambo ya Bibi', 'Skincare', 'Hair Styling'],
        isOnline: true,
        phoneNumber: '+255 777 234 567',
        email: 'sophia.mbeki@kazipoa.co.tz',
      ),
    ];
  }

  static List<ProfessionalModel> getProfessionalsByCategory(String category) {
    return getAllProfessionals()
        .where((pro) => pro.category == category)
        .toList();
  }

  static List<ProfessionalModel> getTopRatedProfessionals() {
    return getAllProfessionals()
        .where((pro) => pro.rating >= 4.5)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  static List<ProfessionalModel> getOnlineProfessionals() {
    return getAllProfessionals()
        .where((pro) => pro.isOnline)
        .toList();
  }
}
