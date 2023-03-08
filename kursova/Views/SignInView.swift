//
//  SignView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI



struct SignInView : View {
    
    @Binding var isUserLogin:Bool
    @State var email = ""
    @State var pass = ""
    @State var isAlert = false
    @State var textAlert = ""
    @State var isProfileShow = false
    
    var body : some View{
        NavigationView{
            //верхний текст
            VStack {
                Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding(.vertical, 20)
                //поля ввода
                VStack{
                    
                    VStack(alignment: .leading){
                        
                        CustomTextField(text: $email, titlet: "Email", texft: "Enter Your Email", maxLettes: 200).padding(.bottom, 15)
                        
                        
                        //Поле с паролем
                        VStack(alignment: .leading){
                            Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                            
                            SecureField("Enter Your Password", text: $pass).autocorrectionDisabled(true)
                            
                            Divider()
                        }
                        
                    }.padding(.horizontal, 6)
                    
                }.padding()
                //кнопки
                VStack{
                    
                    Button(action: {
                        AuthService.shared.signIn(email: email, password: pass) { result in
                            switch result{
                            case .success(_):
                                email.removeAll()
                                isUserLogin.toggle()
                            case .failure(let error):
                                textAlert = "\(error.localizedDescription)"
                                isAlert.toggle()
                            }
                        }
                    }) {
                        Text("Sign In").foregroundColor(Color(.label).opacity(0.75)).frame(width: UIScreen.main.bounds.width - 120).padding()
                        
                    }.background(Color(.systemGray5))
                        .clipShape(Capsule())
                        .padding(.top, 45)
                        .shadow(radius: 5)
                    
                    Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                    
                    HStack(spacing: 8){
                        //Поля "Может зарегестрирован"
                        Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                        
                        
                        
                        NavigationLink {
                            SignUpView(email: $email, pass: $pass)
                        } label: {
                            
                            Text("Sign Up")
                            
                        }.foregroundColor(.blue)
                        
                        
                        
                    }.padding(.top, 25)
                }
            }
        }.alert(textAlert, isPresented: $isAlert) {
            Text("OK")
        }//Ошибка
        .onTapGesture {
                    UIApplication.shared.endEditing()
                }
    
    }
}


struct SignInView_Previews: PreviewProvider {
    @State static var a = false
    static var previews: some View {
        SignInView(isUserLogin: $a)
    }
}
