//
//  SignView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI



struct SignUpView : View {
    
    @State var name = ""
    @Binding  var email:String
    @Binding  var pass:String
    @State var confirmPass = ""
    @State var isAlert = false
    @State var textAlert = ""
    @Environment(\.dismiss) var dismiss
    
    var body : some View{
        //верхний текст
        VStack {
           
            Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding(.vertical, 20)
            //поля ввода
            VStack{
                
                VStack(alignment: .leading){
                    //Поле Имя/Фамилия
                    CustomTextFild(text: $name, titlet: "Name / Surname", texft: "Enter Your Name And Surname").padding(.bottom, 15)
                    
                    //Поле емайл
                    CustomTextFild(text: $email, titlet: "Email", texft: "Enter Your Email").padding(.bottom, 15)
                    
                    //Поле пароль
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                        
                        SecureField("Enter Your Password", text: $pass)
                        
                        Divider()
                    }.padding(.bottom, 15)
                    
                    //Поле confirm апроль
                    VStack(alignment: .leading){
                        
                        Text("Confirm your password").font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                        
                        SecureField("Repeat Your Password", text: $confirmPass)
                        
                        Divider()
                    }
                    
                }.padding(.horizontal, 6)
                
            }.padding()
            //кнопки
            VStack{
                
                Button(action: {
                    guard pass == confirmPass else{
                        textAlert = "Password mismatch"
                        confirmPass.removeAll()
                        isAlert.toggle()
                        return
                    }
                    guard name.count > 3 else{
                        textAlert = "Too short name and surname"
                        isAlert.toggle()
                        return
                    }
                    
                    AuthService.shared.signUp(email: email, password: pass, name_: name) { result in
                        switch result{
                            
                        case .success(let user):
                            textAlert = "Registration with \(user.email!)"
                            isAlert.toggle()
                            name.removeAll()
                            pass.removeAll()
                            confirmPass.removeAll()
                            email.removeAll()
                        case .failure(let error):
                            textAlert = "\(error.localizedDescription)!"
                            isAlert.toggle()
                        }
                    }
                    
                }) {
                    Text("Sign Up").foregroundColor(Color(.label).opacity(0.75)).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                }.background(Color(.systemGray5))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                    .shadow(radius: 5)
                
                Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                //Поля вернуться к входу
                HStack(spacing: 8){
                    
                    Text("Already Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                    
                    Button(action: {
                        dismiss()
                    }) {
                        
                        Text("Sign In")
                        
                    }.foregroundColor(.blue)
                    
                }.padding(.top, 25)
            }
        }.navigationBarBackButtonHidden(true)
            .alert(textAlert, isPresented: $isAlert) {
                Text("OK")
            }
            .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
    }
    
}


struct SignUpView_Previews: PreviewProvider {
    @State static var a = ""
    @State static var b = ""
   
    
    static var previews: some View {
        SignUpView(email: $a, pass: $b)
    }
}

