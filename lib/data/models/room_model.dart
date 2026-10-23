class RoomModel {
  const RoomModel({required this.id, required this.name, required this.category, required this.description, required this.price, required this.capacity, required this.amenities, required this.imageUrl, required this.size, required this.location, required this.rating, required this.badge});
  final String id, name, category, description, imageUrl, size, location, badge;
  final int price, capacity;
  final double rating;
  final List<String> amenities;
  Map<String, dynamic> toMap() => {'id':id,'name':name,'category':category,'description':description,'price':price,'capacity':capacity,'amenities':amenities,'imageUrl':imageUrl,'size':size,'location':location,'rating':rating,'badge':badge};
  factory RoomModel.fromMap(Map<String, dynamic> m) => RoomModel(id: m['id'] ?? '', name: m['name'] ?? '', category: m['category'] ?? '', description: m['description'] ?? '', price: (m['price'] as num?)?.toInt() ?? 0, capacity: (m['capacity'] as num?)?.toInt() ?? 2, amenities: List<String>.from(m['amenities'] ?? const []), imageUrl: m['imageUrl'] ?? '', size: m['size'] ?? '', location: m['location'] ?? '', rating: (m['rating'] as num?)?.toDouble() ?? 4.5, badge: m['badge'] ?? 'POPULAR');
}

const demoRooms = <RoomModel>[
 RoomModel(id:'classic',name:'Classic Comfort Room',category:'Standard',description:'A welcoming retreat with soft linens, thoughtful essentials and calm modern design.',price:3200,capacity:2,amenities:['Wi-Fi','Air conditioning','Work desk','Tea & coffee','Smart TV'],imageUrl:'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1000&q=80',size:'280 sq ft',location:'City Centre',rating:4.7,badge:'GREAT VALUE'),
 RoomModel(id:'deluxe',name:'Deluxe King Room',category:'Deluxe',description:'A spacious king room with refined interiors and thoughtful comforts.',price:5200,capacity:2,amenities:['Wi-Fi','King bed','City view','Smart TV','Mini fridge','Rain shower'],imageUrl:'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1000&q=80',size:'360 sq ft',location:'City Centre',rating:4.9,badge:'GUEST FAVOURITE'),
 RoomModel(id:'family',name:'Family Retreat Suite',category:'Family',description:'Room for everyone, with flexible sleeping arrangements and space to unwind.',price:7400,capacity:4,amenities:['Wi-Fi','Two beds','Smart TV','Mini fridge','Family lounge'],imageUrl:'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1000&q=80',size:'510 sq ft',location:'Garden Wing',rating:4.8,badge:'FAMILY PICK'),
 RoomModel(id:'signature',name:'Grand Signature Suite',category:'Suite',description:'A premium suite with a separate sitting area and elevated comforts.',price:9800,capacity:3,amenities:['Wi-Fi','Living area','King bed','Bathtub','Room service'],imageUrl:'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1000&q=80',size:'640 sq ft',location:'Executive Wing',rating:5.0,badge:'PREMIUM STAY'),
];
