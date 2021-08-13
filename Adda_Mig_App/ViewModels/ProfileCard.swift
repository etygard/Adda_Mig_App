//
//  ProfileCard.swift
//  hushallerska
//
//  Created by Waleerat Gottlieb on 2020-10-25.
//
import Foundation
import UIKit

struct ProfileCard{
    var userId: String
    var name: String
    var age: String
    var profileImage: UIImage!
    var cityAndCountry: String
    var lookingFor: String
    var kindOfHelp: String
    var likedIdArray: [String]
    var rating: String
}

class ProfileCardHelper{
    let openIcon = "\u{27BD}"  //27BD  25C9
    let closeIcon = "\n"
    
    func getAboutMe(aboutme: String) -> String{
        let res = (aboutme != "") ? aboutme : ""
        return res
    }
    
    func getAge(dateOfBirth: Date) -> String{
        let age = abs(dateOfBirth.interval(ofComponent: .year, fromDate: Date()))
        let res = (age > 0) ? String("Age \(age)") : ""
        return res
    }
    
    func getGendar(gendar: String) -> String{
        let res = (gendar != "") ? gendar : ""
        return res
    }
    
    func getStatus(status: String) -> String{
        let res = (status != "") ? status : ""
        return res
    }
    
    func getJob(job: String) -> String{
        let res = (job != "") ? job : ""
        return res
    }
    
    func getEducation(education: String) -> String{
        let res = (education != "") ? education : ""
        return res
    }
    
    func getCityAndCountry(city: String, country: String) -> String {
        let res = (city != "" && country != "") ? "\(city)/\(country)" : ""
        return res 
    }
    
    func getLookingFor(lookingFor: [String]) -> String {
        var resVal = ""
        if lookingFor.count > 0 {
            for (value) in lookingFor {
                resVal += "\(openIcon) \(value) \(closeIcon)"
            }
        } else {
            resVal += " \u{2716} Haven't decided"
        } 
        return resVal
    }
   
    
    func getkindOfHelp(kindOfHelp: [String]) -> String{
        var resVal = ""
        
        if kindOfHelp.count > 0 {
            for (value) in kindOfHelp {
                resVal += "\(openIcon) \(value) \(closeIcon)"
            }
        }else {
            resVal += "\u{2716} Haven't decided"
        }
        
        //"⚡️FlashChat"
        //String literal
        
        return resVal 
        
    }
}

