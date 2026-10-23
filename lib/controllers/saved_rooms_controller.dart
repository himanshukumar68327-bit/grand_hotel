import 'package:get/get.dart';
import '../data/models/room_model.dart';
import '../data/services/firestore_service.dart';
class SavedRoomsController extends GetxController {
 SavedRoomsController(this.service); final FirestoreService service; final RxList<RoomModel> rooms=<RoomModel>[].obs; final RxSet<String> ids=<String>{}.obs; final RxBool loading=false.obs; final RxString error=''.obs;
 Future<void> load() async {loading.value=true;try{final data=await service.getSavedRooms();rooms.assignAll(data);ids.clear();ids.addAll(data.map((r)=>r.id));error.value='';}catch(e){if(e.toString().contains('verified')){clear();}else{error.value='Unable to load saved rooms.';}}finally{loading.value=false;}}
 Future<bool> toggle(RoomModel room) async {try{await service.toggleSaved(room);await load();return ids.contains(room.id);}catch(e){error.value=e.toString().replaceFirst('Exception: ','');return false;}}
 bool isSaved(String id)=>ids.contains(id); void clear(){rooms.clear();ids.clear();error.value='';}
}
