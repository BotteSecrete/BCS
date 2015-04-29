import com.esri.ags.tasks.supportClasses.Query;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.net.SharedObject;

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.http.mxml.HTTPService;

import widgets.MyWidget.MyFirstWidget;

private function sendMail(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building Completed in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.responsable.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	
		var _destiName:String = configData.configXML.responsable.name;
		
		var emailService:HTTPService = new HTTPService;
		emailService.url = "php/mail.php";
		emailService.method = "POST";
		emailService.resultFormat = "xml";
		emailService.useProxy = false;
		emailService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/email1.png";
		toastMessage.sampleCaption = "Responsable has been notified";
		toastMessage.timeToLive = 2;
		MyFirstWidget.index.simpleToaster.toast(toastMessage);	
}

private function sendMailPresta(id:String, locaID:String, projID:Number, _info:String):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building rejected in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.prestataire.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailPresta.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName, info:_info});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Surveyor has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
private function sendMailPrestaValid(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building validated in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.prestataire.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailPresta.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Surveyor has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}

private function sendMailLect1Reject(id:String, locaID:String, projID:Number, _info:String):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building rejected in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur1.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailPresta.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName, info:_info});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
private function sendMailLect1Valid(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building validated in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur1.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailLect.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
private function sendMailLect1Complete(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building Completed in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur1.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mail.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}

private function sendMailLect2Reject(id:String, locaID:String, projID:Number, _info:String):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building rejected in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur2.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailPresta.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName, info:_info});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}

private function sendMailLect2Valid(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building validated in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur2.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailLect.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
private function sendMailLect2Complete(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building Completed in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur2.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mail.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}

private function sendMailLect3Reject(id:String, locaID:String, projID:Number, _info:String):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building rejected in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur3.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailPresta.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName, info:_info});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
private function sendMailLect3Valid(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building validated in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur3.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mailLect.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}

private function sendMailLect3Complete(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "BCS@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Building Completed in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.lecteur3.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Jeddah Buildings";
	
	var _destiName:String = configData.configXML.responsable.name;
	
	var emailPrestaService:HTTPService = new HTTPService;
	emailPrestaService.url = "php/mail.php";
	emailPrestaService.method = "POST";
	emailPrestaService.resultFormat = "xml";
	emailPrestaService.useProxy = false;
	emailPrestaService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/email1.png";
	toastMessage.sampleCaption = "Reader has been notified";
	toastMessage.timeToLive = 2;
	MyFirstWidget.index.simpleToaster.toast(toastMessage);
}
