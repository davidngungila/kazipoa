import 'package:kazipoa/core/models/service_model.dart';

class SearchService {
  static List<ServiceModel> searchServices(String query) {
    if (query.isEmpty) return ServicesData.getAllServices();
    
    final lowerQuery = query.toLowerCase();
    return ServicesData.getAllServices().where((service) {
      return service.name.toLowerCase().contains(lowerQuery) ||
             service.category.toLowerCase().contains(lowerQuery) ||
             service.description.toLowerCase().contains(lowerQuery) ||
             service.keywords.any((keyword) => keyword.contains(lowerQuery));
    }).toList();
  }

  static List<ServiceModel> filterByCategory(List<ServiceModel> services, String category) {
    return services.where((service) => service.category == category).toList();
  }

  static List<ServiceModel> filterByPriceRange(List<ServiceModel> services, double minPrice, double maxPrice) {
    return services.where((service) => 
      service.averagePrice >= minPrice && service.averagePrice <= maxPrice
    ).toList();
  }

  static List<String> getSearchSuggestions(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    final suggestions = <String>{};
    
    for (final service in ServicesData.getAllServices()) {
      if (service.name.toLowerCase().contains(lowerQuery)) {
        suggestions.add(service.name);
      }
      if (service.category.toLowerCase().contains(lowerQuery)) {
        suggestions.add(service.category);
      }
      for (final keyword in service.keywords) {
        if (keyword.contains(lowerQuery)) {
          suggestions.add(keyword);
        }
      }
    }
    
    return suggestions.take(5).toList();
  }
}
