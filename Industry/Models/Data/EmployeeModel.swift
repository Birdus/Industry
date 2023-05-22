struct Employee: Codable, Equatable {
    let id: Int
    let firstName: String
    let secondName: String
    let password: String
    let role: String
    let divisionId: Int
    let lastName: String
    let serviceNumber: Int
    let oneCPass: Int?
    let post: String
    let division: Division
    var laborCosts: [LaborCost]?
}

extension Employee: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard
            let id = json["id"] as? Int,
            let firstName = json["firstName"] as? String,
            let secondName = json["secondName"] as? String,
            let password = json["password"] as? String,
            let role = json["role"] as? String,
            let divisionId = json["divisionId"] as? Int,
            let lastName = json["lastName"] as? String,
            let serviceNumber = json["serviceNumber"] as? Int,
            let post = json["post"] as? String,
            let divisionJson = json["division"] as? [String: Any],
            let laborCostsJson = json["laborCosts"] as? [[String:Any]] else {
            return nil
        }
        
        let oneCPass = json["oneCPass"] as? Int
        let laborCosts = laborCostsJson.compactMap { LaborCost.decodeJSON(json: $0) }
        guard let division = Division.decodeJSON(json: divisionJson) else {
            return nil
        }
        
        return Employee(id: id, firstName: firstName, secondName: secondName, password: password, role: role, divisionId: divisionId, lastName: lastName, serviceNumber: serviceNumber, oneCPass: oneCPass, post: post, division: division, laborCosts: laborCosts)
    }
}
