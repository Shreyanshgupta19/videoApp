import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';


pickVideo() async{
  final picker = ImagePicker();
  XFile? videoFile;
  try{
   videoFile =  await picker.pickVideo(source: ImageSource.gallery);
   return videoFile!.path;
  }
      catch(e){
    print("Error Picking Video : $e");
      }
}