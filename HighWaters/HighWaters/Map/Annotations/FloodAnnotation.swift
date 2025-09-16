//
//  FloodAnnotation.swift
//  HighWaters
//
//  Created by Bianca Maciel on 09/09/25.
//

import MapKit
import SwiftUI
import Foundation


final class FloodAnnotation: MKPointAnnotation {
    let flood: FloodReport
    
    init(_ flood: FloodReport) {
        self.flood = flood
    }
}
