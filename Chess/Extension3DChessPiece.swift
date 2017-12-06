//
//  Created by George Torres  on 10/3/17.
//  All rights reserved.
//

import SceneKit

typealias ChessPiece3D = SCNNode

extension ChessPiece3D: Piece3D {
    
    var x: CGFloat {
        
        get {
            return CGFloat(self.position.x)
        }
        set {
            self.position.x = Float(newValue)
        }
        
    }
    
    var y: CGFloat {
        
        get {
            return CGFloat(self.position.y)
        }
        set {
            self.position.y = Float(newValue)
        }
        
    }
    
    
    var z: CGFloat {
        
        get {
            return CGFloat(self.position.z)
        }
        set {
            self.position.z = Float(newValue)
        }
        
    }
    
    
    var color: String {
        
        get {
           // print(self.geometry?.firstMaterial?.diffuse.contents)
            //return String(describing: self.geometry?.firstMaterial?.diffuse.contents)
            return "white"
        }
        
    }
    
}



