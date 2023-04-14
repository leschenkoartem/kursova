//
//  SignView.swift
//  KursachAuctions
//
//  Created by Artem Leschenko on 20.02.2023.
//

import SwiftUI



struct SignInView : View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
 
    @ObservedObject private var vm = SignInUpViewModel()
    
    
    var body : some View{
        NavigationView{
            //верхний текст
            VStack {
                HStack{
                    LanguageButton(width: 60.0, height: 40.0).padding(.top, 6)
                }
                Text("Sign In".localized(language)).fontWeight(.heavy).font(.largeTitle).padding(.vertical, 20)
                //поля ввода
                VStack{
                    VStack(alignment: .leading){
                        CustomTextField(text: $vm.email, titleOfField: "Email".localized(language), placeholder: "Enter Your Email".localized(language), maxLettes: 200)
                            .padding(.bottom, 15)
                        
                        //Поле с паролем
                        VStack(alignment: .leading){
                            Text("Password".localized(language)).font(.headline).fontWeight(.light).foregroundColor(Color(.label).opacity(0.75))
                            
                            SecureField("Enter Your Password".localized(language), text: $vm.pass)
                            .autocorrectionDisabled(true)
                            
                            Divider()
                        }
                    }.padding(.horizontal, 6)
                }.padding()
                //кнопки
                VStack{
                    Button{
                        vm.signIn()
                    } label: {
                        Text("Sign In".localized(language)).foregroundColor(Color(.label).opacity(0.75)).frame(width: UIScreen.main.bounds.width - 120).padding()
                    }.background(Color(.systemGray5))
                        .clipShape(Capsule())
                        .padding(.top, 45)
                        .shadow(radius: 5)
                    
                    Text("(or)".localized(language)).foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                    
                    HStack(spacing: 8){
                        //Поля "Может зарегестрирован"
                        Text("Don't Have An Account ?".localized(language)).foregroundColor(Color.gray.opacity(0.5))
                        
                        NavigationLink {
                            SignUpView(vm: vm)
                        } label: {
                            Text("Sign Up".localized(language))
                        }.foregroundColor(.blue)
                        
                    }.padding(.top, 25)
                }
            }
        }.alert(vm.textAlert, isPresented: $vm.isAlert) {
            Text("OK")
        }//Ошибка
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
