import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final List<String> keywords;
  final double averagePrice;
  final String priceUnit;
  final List<SubService> subServices;

  ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.keywords,
    required this.averagePrice,
    required this.priceUnit,
    required this.subServices,
  });
}

class SubService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String priceUnit;

  SubService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.priceUnit,
  });
}

// Comprehensive services data for Tanzania
class ServicesData {
  static List<ServiceModel> getAllServices() {
    return [
      // Plumbing Services
      ServiceModel(
        id: 'plumbing',
        name: 'Ufundi wa Mabomba',
        category: 'Bomba',
        description: 'Wataalamu wa usakinishaji na matengenezo ya mabomba',
        icon: Icons.plumbing,
        keywords: ['mabomba', 'plumbing', 'ufundi', 'bomb', 'water', 'maji'],
        averagePrice: 25000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'plumbing_install', name: 'Usakinishaji Mabomba', description: 'Usakinishaji wa mabomba mapya', price: 30000, priceUnit: '/kazi'),
          SubService(id: 'plumbing_repair', name: 'Matengenezo Mabomba', description: 'Rekebisha mabomba yaliovunjika', price: 25000, priceUnit: '/saa'),
          SubService(id: 'plumbing_emergency', name: 'Dharura Mabomba', description: 'Matatizo ya dharura ya mabomba', price: 40000, priceUnit: '/saa'),
        ],
      ),
      
      // Electrical Services
      ServiceModel(
        id: 'electrical',
        name: 'Ufundi wa Umeme',
        category: 'Umeme',
        description: 'Wataalamu wa usakinishaji na matengenezo ya umeme',
        icon: Icons.electrical_services,
        keywords: ['umeme', 'electrical', 'ufundi', 'stima', 'power', 'lightning'],
        averagePrice: 30000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'electrical_install', name: 'Usakinishaji Umeme', description: 'Usakinishaji wa mfumo wa umeme', price: 35000, priceUnit: '/kazi'),
          SubService(id: 'electrical_repair', name: 'Matengenezo Umeme', description: 'Rekebisha matatizo ya umeme', price: 30000, priceUnit: '/saa'),
          SubService(id: 'electrical_emergency', name: 'Dharura Umeme', description: 'Matatizo ya dharura ya umeme', price: 45000, priceUnit: '/saa'),
        ],
      ),
      
      // Cleaning Services
      ServiceModel(
        id: 'cleaning',
        name: 'Huduma za Usafi',
        category: 'Usafi',
        description: 'Wataalamu wa usafi wa nyumba na ofisi',
        icon: Icons.cleaning_services,
        keywords: ['usafi', 'cleaning', 'safi', 'huduma', 'nyumba', 'ofisi'],
        averagePrice: 20000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'cleaning_house', name: 'Usafi wa Nyumba', description: 'Usafi wa nyumba kamili', price: 20000, priceUnit: '/saa'),
          SubService(id: 'cleaning_office', name: 'Usafi wa Ofisi', description: 'Usafi wa ofisi na biashara', price: 25000, priceUnit: '/saa'),
          SubService(id: 'cleaning_deep', name: 'Usafi wa Kina', description: 'Usafi wa kina wa nyumba', price: 30000, priceUnit: '/kazi'),
        ],
      ),
      
      // Construction Services
      ServiceModel(
        id: 'construction',
        name: 'Ujenzi',
        category: 'Ujenzi',
        description: 'Wataalamu wa ujenzi na ukarabati',
        icon: Icons.construction,
        keywords: ['ujenzi', 'construction', 'nyumba', 'karabati', 'renovation'],
        averagePrice: 35000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'construction_build', name: 'Ujenzi wa Nyumba', description: 'Ujenzi mpya wa nyumba', price: 40000, priceUnit: '/saa'),
          SubService(id: 'construction_repair', name: 'Ukarabati', description: 'Ukarabati wa nyumba', price: 35000, priceUnit: '/saa'),
          SubService(id: 'construction_paint', name: 'Uchoraji', description: 'Uchoraji wa nyumba', price: 15000, priceUnit: '/saa'),
        ],
      ),
      
      // Automotive Services
      ServiceModel(
        id: 'automotive',
        name: 'Mekanika ya Gari',
        category: 'Gari',
        description: 'Wataalamu wa matengenezo ya gari',
        icon: Icons.directions_car,
        keywords: ['gari', 'mekanika', 'car', 'automotive', 'matengenezo', 'repair'],
        averagePrice: 25000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'car_repair', name: 'Matengenezo Gari', description: 'Matengenezo ya kawaida ya gari', price: 25000, priceUnit: '/saa'),
          SubService(id: 'car_service', name: 'Huduma ya Gari', description: 'Huduma ya mara kwa mara ya gari', price: 20000, priceUnit: '/kazi'),
          SubService(id: 'car_emergency', name: 'Dharura Gari', description: 'Msaada wa dharura ya gari', price: 35000, priceUnit: '/saa'),
        ],
      ),
      
      // Electronics Repair
      ServiceModel(
        id: 'electronics',
        name: 'Marekebisho ya Elektroniki',
        category: 'Elektroniki',
        description: 'Wataalamu wa marekebisho ya vifaa vya elektroniki',
        icon: Icons.devices,
        keywords: ['elektroniki', 'electronics', 'simu', 'computer', 'laptop', 'TV'],
        averagePrice: 22000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'phone_repair', name: 'Marekebisho ya Simu', description: 'Rekebisha simu za mkononi', price: 20000, priceUnit: '/kazi'),
          SubService(id: 'computer_repair', name: 'Marekebisho ya Kompyuta', description: 'Rekebisha kompyuta na laptop', price: 25000, priceUnit: '/saa'),
          SubService(id: 'tv_repair', name: 'Marekebisho ya TV', description: 'Rekebisha televisheni na vifaa vya umeme', price: 22000, priceUnit: '/saa'),
        ],
      ),
      
      // Gardening & Landscaping
      ServiceModel(
        id: 'gardening',
        name: 'Mazingira na Bustani',
        category: 'Bustani',
        description: 'Wataalamu wa bustani na mazingira',
        icon: Icons.nature,
        keywords: ['bustani', 'gardening', 'miti', 'flowers', 'landscaping', 'mazingira'],
        averagePrice: 18000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'garden_design', name: 'Ubunifu wa Bustani', description: 'Kubuni bustani nzuri', price: 20000, priceUnit: '/saa'),
          SubService(id: 'garden_maintenance', name: 'Ulinzi wa Bustani', description: 'Ulinzi wa mara kwa mara wa bustani', price: 15000, priceUnit: '/saa'),
          SubService(id: 'lawn_care', name: 'Matunzo ya Nyasi', description: ' kukata na kudumisha nyasi', price: 12000, priceUnit: '/saa'),
        ],
      ),
      
      // Catering Services
      ServiceModel(
        id: 'catering',
        name: 'Huduma za Chakula',
        category: 'Chakula',
        description: 'Wataalamu wa huduma za chakula na mikahawa',
        icon: Icons.restaurant,
        keywords: ['chakula', 'catering', 'mikahawa', 'food', 'cooking', 'chef'],
        averagePrice: 28000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'catering_event', name: 'Chakula cha Tukio', description: 'Huduma ya chakula kwa matukio', price: 30000, priceUnit: '/saa'),
          SubService(id: 'catering_daily', name: 'Chakula cha Kila Siku', description: 'Huduma ya chakula cha kila siku', price: 25000, priceUnit: '/siku'),
          SubService(id: 'cooking_class', name: 'Darasa la Upishi', description: 'Mafunzo ya upishi', price: 20000, priceUnit: '/saa'),
        ],
      ),
      
      // Beauty & Personal Care
      ServiceModel(
        id: 'beauty',
        name: 'Mapambo na Nguo',
        category: 'Mapambo',
        description: 'Wataalamu wa mapambo na huduma za binafsi',
        icon: Icons.spa,
        keywords: ['mapambo', 'beauty', 'salon', 'hair', 'makeup', 'spa'],
        averagePrice: 15000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'hair_salon', name: 'Saluni ya Nywele', description: 'Kukata na kupamba nywele', price: 15000, priceUnit: '/saa'),
          SubService(id: 'makeup', name: 'Mapambo ya Uso', description: 'Huduma ya mapambo ya uso', price: 20000, priceUnit: '/saa'),
          SubService(id: 'massage', name: 'Masaji', description: 'Huduma ya masaji ya kupumua', price: 18000, priceUnit: '/saa'),
        ],
      ),
      
      // Photography & Videography
      ServiceModel(
        id: 'photography',
        name: 'Picha na Video',
        category: 'Picha',
        description: 'Wataalamu wa upigaji picha na video',
        icon: Icons.camera_alt,
        keywords: ['picha', 'photography', 'video', 'camera', 'shooting', 'events'],
        averagePrice: 35000,
        priceUnit: '/saa',
        subServices: [
          SubService(id: 'event_photo', name: 'Picha za Matukio', description: 'Upigaji picha za matukio', price: 40000, priceUnit: '/saa'),
          SubService(id: 'portrait_photo', name: 'Picha za Portreti', description: 'Picha za binafsi na familia', price: 30000, priceUnit: '/saa'),
          SubService(id: 'video_production', name: 'Utengenezaji Video', description: 'Utengenezaji wa video za kitaalamu', price: 45000, priceUnit: '/saa'),
        ],
      ),
    ];
  }

  static List<ServiceModel> searchServices(String query) {
    if (query.isEmpty) return getAllServices();
    
    final lowerQuery = query.toLowerCase();
    return getAllServices().where((service) {
      return service.name.toLowerCase().contains(lowerQuery) ||
             service.category.toLowerCase().contains(lowerQuery) ||
             service.description.toLowerCase().contains(lowerQuery) ||
             service.keywords.any((keyword) => keyword.contains(lowerQuery));
    }).toList();
  }

  static List<String> getAllCategories() {
    return getAllServices().map((service) => service.category).toSet().toList();
  }
}
