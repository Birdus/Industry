// MARK: - ErrorManager

/// ErrorManager handles networking errors in the Industry app.
enum INDNetworkingError: Error, Equatable {
    // 1xx Informational
    case `continue`
    case switchingProtocols
    case processing
    
    // 2xx Success
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case IMUsed
    
    // 3xx Redirection
    case multipleChoices
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case temporaryRedirect
    case permanentRedirect
    
    // 4xx Client Error
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case unavailableForLegalReasons
    
    // 5xx Server Error
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    
    // Custom Errors
    case missingHTTPResponse
    case unexpectedResponse(message: String)
    case invalidAccessToken
    case encodingFailed
    case decodingFailed
    
    // ... Add more custom errors here
    
    static let errorDomain = "Industry.NetworkingError"
    
    /// Returns the corresponding error code for the error.
    var errorCode: Int {
        switch self {
        // 1xx Informational
        case .continue:
            return 100
        case .switchingProtocols:
            return 101
        case .processing:
            return 102

        // 2xx Success
        case .ok:
            return 200
        case .created:
            return 201
        case .accepted:
            return 202
        case .nonAuthoritativeInformation:
            return 203
        case .noContent:
            return 204
        case .resetContent:
            return 205
        case .partialContent:
            return 206
        case .multiStatus:
            return 207
        case .alreadyReported:
            return 208
        case .IMUsed:
            return 226

        // 3xx Redirection
        case .multipleChoices:
            return 300
        case .movedPermanently:
            return 301
        case .found:
            return 302
        case .seeOther:
            return 303
        case .notModified:
            return 304
        case .useProxy:
            return 305
        case .temporaryRedirect:
            return 307
        case .permanentRedirect:
            return 308

        // 4xx Client Error
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .paymentRequired:
            return 402
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .methodNotAllowed:
            return 405
        case .notAcceptable:
            return 406
        case .proxyAuthenticationRequired:
            return 407
        case .requestTimeout:
            return 408
        case .conflict:
            return 409
        case .gone:
            return 410
        case .lengthRequired:
            return 411
        case .preconditionFailed:
            return 412
        case .payloadTooLarge:
            return 413
        case .uriTooLong:
            return 414
        case .unsupportedMediaType:
            return 415
        case .rangeNotSatisfiable:
            return 416
        case .expectationFailed:
            return 417
        case .imATeapot:
            return 418
        case .misdirectedRequest:
            return 421
        case .unprocessableEntity:
            return 422
        case .locked:
            return 423
        case .failedDependency:
            return 424
        case .upgradeRequired:
            return 426
        case .preconditionRequired:
            return 428
        case .tooManyRequests:
            return 429
        case .requestHeaderFieldsTooLarge:
            return 431
        case .unavailableForLegalReasons:
            return 451

        // 5xx Server Error
        case .internalServerError:
            return 500
        case .notImplemented:
            return 501
        case .badGateway:
            return 502
        case .serviceUnavailable:
            return 503
        case .gatewayTimeout:
            return 504
        case .httpVersionNotSupported:
            return 505
        case .variantAlsoNegotiates:
            return 506
        case .insufficientStorage:
            return 507
        case .loopDetected:
            return 508
        case .notExtended:
            return 510
        case .networkAuthenticationRequired:
            return 511

        // Custom Errors
        case .missingHTTPResponse:
            return 1001
        case .unexpectedResponse:
            return 1002
        case .invalidAccessToken:
            return 1003
        case .encodingFailed:
            return 1004
        case .decodingFailed:
            return 1005
        
        // ... Add more custom errors here
        }
    }
    
    /// Returns the corresponding error message for the error.
    var errorMessage: String {
        switch self {
        // 1xx Informational
        case .continue:
            return "Продолжай".localized
        case .switchingProtocols:
            return "Переключение протоколов".localized
        case .processing:
            return "Обработка".localized

        // 2xx Success
        case .ok:
            return "OK".localized
        case .created:
            return "Создано".localized
        case .accepted:
            return "Принято".localized
        case .nonAuthoritativeInformation:
            return "Информация не авторитетна".localized
        case .noContent:
            return "Нет контента".localized
        case .resetContent:
            return "Сброс контента".localized
        case .partialContent:
            return "Частичный контент".localized
        case .multiStatus:
            return "Многостатусный".localized
        case .alreadyReported:
            return "Уже сообщено".localized
        case .IMUsed:
            return "IM использован".localized

        // 3xx Redirection
        case .multipleChoices:
            return "Множество выборов".localized
        case .movedPermanently:
            return "Перемещено навсегда".localized
        case .found:
            return "Найдено".localized
        case .seeOther:
            return "Смотреть другое".localized
        case .notModified:
            return "Не изменено".localized
        case .useProxy:
            return "Использовать прокси".localized
        case .temporaryRedirect:
            return "Временное перенаправление".localized
        case .permanentRedirect:
            return "Постоянное перенаправление".localized

        // 4xx Client Error
        case .badRequest:
            return "Неверный запрос".localized
        case .unauthorized:
            return "Неавторизованный".localized
        case .paymentRequired:
            return "Требуется оплата".localized
        case .forbidden:
            return "Запрещено".localized
        case .notFound:
            return "Не найдено".localized
        case .methodNotAllowed:
            return "Метод не разрешен".localized
        case .notAcceptable:
            return "Неприемлемо".localized
        case .proxyAuthenticationRequired:
            return "Требуется аутентификация прокси".localized
        case .requestTimeout:
            return "Таймаут запроса".localized
        case .conflict:
            return "Конфликт".localized
        case .gone:
            return "Ушел".localized
        case .lengthRequired:
            return "Требуется длина".localized
        case .preconditionFailed:
            return "Предусловие не выполнено".localized
        case .payloadTooLarge:
            return "Полезная нагрузка слишком большая".localized
        case .uriTooLong:
            return "URI слишком длинный".localized
        case .unsupportedMediaType:
            return "Неподдерживаемый тип медиа".localized
        case .rangeNotSatisfiable:
            return "Диапазон не удовлетворительный".localized
        case .expectationFailed:
            return "Ожидание не выполнено".localized
        case .misdirectedRequest:
            return "Неправильно направленный запрос".localized
        case .unprocessableEntity:
            return "Неразбираемая сущность".localized
        case .locked:
            return "Заблокировано".localized
        case .failedDependency:
            return "Не выполнена зависимость".localized
        case .upgradeRequired:
            return "Требуется обновление".localized
        case .preconditionRequired:
            return "Требуется предусловие".localized
        case .tooManyRequests:
            return "Слишком много запросов".localized
        case .requestHeaderFieldsTooLarge:
            return "Поля заголовка запроса слишком большие".localized
        case .unavailableForLegalReasons:
            return "Недоступно по юридическим причинам".localized

        // 5xx Server Error
        case .internalServerError:
            return "Внутренняя ошибка сервера".localized
        case .notImplemented:
            return "Не реализовано".localized
        case .badGateway:
            return "Плохой шлюз".localized
        case .serviceUnavailable:
            return "Сервис недоступен".localized
        case .gatewayTimeout:
            return "Таймаут шлюза".localized
        case .httpVersionNotSupported:
            return "Версия HTTP не поддерживается".localized
        case .variantAlsoNegotiates:
            return "Вариант тоже согласовывает".localized
        case .insufficientStorage:
            return "Недостаточно места для хранения".localized
        case .loopDetected:
            return "Обнаружен цикл".localized
        case .notExtended:
            return "Не расширено".localized
        case .networkAuthenticationRequired:
            return "Требуется сетевая аутентификация".localized
        case .imATeapot:
            return "Ошибка тайм-аута сетевого подключения".localized

        // Custom Errors
        case .missingHTTPResponse:
            return "Отсутствует HTTP-ответ".localized
        case .unexpectedResponse(let message):
            var txt = "Неожиданный ответ: ".localized
            txt += message
            return txt
        case .invalidAccessToken:
            return "Недействительный токен доступа".localized
        case .encodingFailed:
            return "Ошибка кодирования".localized
        case .decodingFailed:
            return "Ошибка декодирования".localized
        
        // ... Add more custom errors here
        
        }
    }

    
    /// Initializes an error with a given HTTP status code and optional message.
    init(statusCode: Int?, message: String? = nil) {
        switch statusCode {
        // 1xx Informational
        case 100:
            self = .continue
        case 101:
            self = .switchingProtocols
        case 102:
            self = .processing
            
        // 2xx Success
        case 200:
            self = .ok
        case 201:
            self = .created
        case 202:
            self = .accepted
        case 203:
            self = .nonAuthoritativeInformation
        case 204:
            self = .noContent
        case 205:
            self = .resetContent
        case 206:
            self = .partialContent
        case 207:
            self = .multiStatus
        case 208:
            self = .alreadyReported
        case 226:
            self = .IMUsed

        // 3xx Redirection
        case 300:
            self = .multipleChoices
        case 301:
            self = .movedPermanently
        case 302:
            self = .found
        case 303:
            self = .seeOther
        case 304:
            self = .notModified
        case 305:
            self = .useProxy
        case 307:
            self = .temporaryRedirect
        case 308:
            self = .permanentRedirect

        // 4xx Client Error
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 402:
            self = .paymentRequired
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 406:
            self = .notAcceptable
        case 407:
            self = .proxyAuthenticationRequired
        case 408:
            self = .requestTimeout
        case 409:
            self = .conflict
        case 410:
            self = .gone
        case 411:
            self = .lengthRequired
        case 412:
            self = .preconditionFailed
        case 413:
            self = .payloadTooLarge
        case 414:
            self = .uriTooLong
        case 415:
            self = .unsupportedMediaType
        case 416:
            self = .rangeNotSatisfiable
        case 417:
            self = .expectationFailed
        case 418:
            self = .imATeapot
        case 421:
            self = .misdirectedRequest
        case 422:
            self = .unprocessableEntity
        case 423:
            self = .locked
        case 424:
            self = .failedDependency
        case 426:
            self = .upgradeRequired
        case 428:
            self = .preconditionRequired
        case 429:
            self = .tooManyRequests
        case 431:
            self = .requestHeaderFieldsTooLarge
        case 451:
            self = .unavailableForLegalReasons

        // 5xx Server Error
        case 500:
            self = .internalServerError
        case 501:
            self = .notImplemented
        case 502:
            self = .badGateway
        case 503:
            self = .serviceUnavailable
        case 504:
            self = .gatewayTimeout
        case 505:
            self = .httpVersionNotSupported
        case 506:
            self = .variantAlsoNegotiates
        case 507:
            self = .insufficientStorage
        case 508:
            self = .loopDetected
        case 510:
            self = .notExtended
        case 511:
            self = .networkAuthenticationRequired

        // Custom Errors
        case 1001:
            self = .missingHTTPResponse
        case 1002:
            if let message = message {
                self = .unexpectedResponse(message: message)
            } else {
                self = .missingHTTPResponse
            }
        case 1003:
            self = .invalidAccessToken
        case 1004:
            self = .encodingFailed
        case 1005:
            self = .decodingFailed

        // ... Add more custom errors here
        default:
            self = .missingHTTPResponse
        }
    }

    init(_ error: Error) {
            if let error = error as? INDNetworkingError {
                self = error
            } else {
                self = .unexpectedResponse(message: error.localizedDescription)
            }
        }
}
