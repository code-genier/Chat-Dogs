import 'package:chat_app/Services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/HelperFunction.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  /// login
  Future loginUserWithEmailAndPassword(String _email, String _password) async {
    try {
      User user = (
          await firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password)
      ).user!;

    return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

 /// register
 Future registerUserWithEmailAndPassword(String _fullname, String _email, String _password) async {
   try {
   User user = (await firebaseAuth.createUserWithEmailAndPassword(
   email: _email , password: _password)).user!;

    await DatabaseService(uid: user.uid).savingUserData(_fullname, _email);
    return true;
   } on FirebaseAuthException catch (e) {
     return e.message;
   }
 }

 /// sign out

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}