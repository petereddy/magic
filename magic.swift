import Foundation

func underscoreToCamelCase(string: String) -> String {
  let items = string.componentsSeparatedByString("_")
  return items.reduce("") { $0.isEmpty ? $1 : $0 + $1.capitalizedString }
}


extension NSObject {
    class func fromJson(jsonInfo: NSDictionary) -> Self {
        var object = self()
        
        (object as NSObject).load(jsonInfo)

        return object
    }
    
    func load(jsonInfo: NSDictionary) {
        for (key, value) in jsonInfo {
            let keyName = key as String
            
            if (respondsToSelector(NSSelectorFromString(keyName))) {
                setValue(value, forKey: keyName)
            } else {
                let camelCaseName = underscoreToCamelCase(keyName)
                if (respondsToSelector(NSSelectorFromString(camelCaseName))) {
                    setValue(value, forKey: camelCaseName)
                }
            }
        }
    }
    
    func propertyNames() -> [String] {
        var names: [String] = []
        var count: UInt32 = 0
        var properties = class_copyPropertyList(classForCoder, &count)
        for var i = 0; i < Int(count); ++i {
            let property: objc_property_t = properties[i]
            let name: String =
            NSString.stringWithCString(property_getName(property), encoding: NSUTF8StringEncoding)
            names.append(name)
        }
        free(properties)
        return names
    }
    
    func asJson() -> NSDictionary {
        var json = NSMutableDictionary.dictionary()
        
        for name in propertyNames() {
            if let value: AnyObject = valueForKey(name) {
                json[name] = value
            }
        }
        
        
        return json
    }
}
