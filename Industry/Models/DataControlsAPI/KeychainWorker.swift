//
//  KeychainWorker.swift
//  Industry
//
//  Created by  Даниил on 27.05.2023.
//

import Foundation
import KeychainSwift

protocol KeychainWorkerProtocol {
    static var keychain: KeychainSwift { get }
    static var KEY_ACCESS_TOKEN: String { get }
    static var KEY_ACCESS_TOKEN_EXPIRE: String { get }
    static var KEY_ACCESS_TOKEN_NBF: String { get }
    static var KEY_AUTH_BODY_EMAIL: String { get }
    static var KEY_AUTH_BODY_PASSWORD: String { get }
    
    func saveAuthTokens(tokens: TokenInfo)
    func getAccessToken() -> TokenInfo?
    var haveAuthTokens: Bool { get }
    func dropTokens()
    
    func saveAuthBody(authBody: AuthBody)
    func getAccessAuthBody() -> AuthBody?
    var haveAuthBody: Bool { get }
    func dropAuthBody()
}

extension KeychainWorkerProtocol {
    static var keychain: KeychainSwift {
        return KeychainSwift()
    }
    
    func saveAuthTokens(tokens: TokenInfo) {
        Self.keychain.set(tokens.token, forKey: Self.KEY_ACCESS_TOKEN)
        Self.keychain.set(String(tokens.expiresAt), forKey: Self.KEY_ACCESS_TOKEN_EXPIRE)
        Self.keychain.set(String(tokens.notValidBefore), forKey: Self.KEY_ACCESS_TOKEN_NBF)
    }
    
    func getAccessToken() -> TokenInfo? {
        guard let token = Self.keychain.get(Self.KEY_ACCESS_TOKEN),
              let expiresAtString = Self.keychain.get(Self.KEY_ACCESS_TOKEN_EXPIRE),
              let expiresAt = Int64(expiresAtString),
              let nbfString = Self.keychain.get(Self.KEY_ACCESS_TOKEN_NBF),
              let nbfAt = Int64(nbfString)
        else {
            return nil
        }
        return TokenInfo(token: token, expiresAt: expiresAt, notValidBefore: nbfAt)
    }
    
    var haveAuthTokens: Bool {
        return getAccessToken() != nil
    }
    
    func dropTokens() {
        Self.keychain.delete(Self.KEY_ACCESS_TOKEN)
        Self.keychain.delete(Self.KEY_ACCESS_TOKEN_EXPIRE)
        Self.keychain.delete(Self.KEY_ACCESS_TOKEN_NBF)
    }
    
    func saveAuthBody(authBody: AuthBody) {
        Self.keychain.set(authBody.email, forKey: Self.KEY_AUTH_BODY_EMAIL)
        Self.keychain.set(authBody.password, forKey: Self.KEY_AUTH_BODY_PASSWORD)
    }
    
    func getAccessAuthBody() -> AuthBody? {
        guard let email = Self.keychain.get(Self.KEY_AUTH_BODY_EMAIL),
              let password = Self.keychain.get(Self.KEY_AUTH_BODY_PASSWORD) else { return nil }
        return AuthBody(email: email, password: password)
    }
    
    var haveAuthBody: Bool {
        return !(getAccessAuthBody()?.email.isNullOrWhiteSpace ?? true) && !(getAccessAuthBody()?.password.isNullOrWhiteSpace ?? true)
    }
    
    func dropAuthBody() {
        Self.keychain.delete(Self.KEY_AUTH_BODY_EMAIL)
        Self.keychain.delete(Self.KEY_AUTH_BODY_PASSWORD)
    }
}
