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
    static var KEY_REFRESH_TOKEN: String { get }
    static var KEY_REFRESH_TOKEN_EXPIRE: String { get }
    static var KEY_AUTH_BODY_EMAIL: String { get }
    static var KEY_AUTH_BODY_PASSWORD: String { get }
    
    func saveAuthTokens(tokens: TokenInfo)
    func getAccessToken() -> TokenInfo?
    func getRefreshToken() -> TokenInfo
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
    }
    
    func getAccessToken() -> TokenInfo? {
        guard let token = Self.keychain.get(Self.KEY_ACCESS_TOKEN),
              let expiresAtString = Self.keychain.get(Self.KEY_ACCESS_TOKEN_EXPIRE),
              let expiresAt = Int64(expiresAtString)
        else {
            return nil
        }
        return TokenInfo(token: token, expiresAt: expiresAt)
    }
    
    func getRefreshToken() -> TokenInfo {
        let token = Self.keychain.get(Self.KEY_REFRESH_TOKEN) ?? ""
        let expiresAt = Int64(Self.keychain.get(Self.KEY_REFRESH_TOKEN_EXPIRE) ?? "0") ?? 0
        return TokenInfo(token: token, expiresAt: expiresAt)
    }
    
    var haveAuthTokens: Bool {
        return getAccessToken() != nil
    }
    
    func dropTokens() {
        Self.keychain.delete(Self.KEY_ACCESS_TOKEN)
        Self.keychain.delete(Self.KEY_ACCESS_TOKEN_EXPIRE)
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
