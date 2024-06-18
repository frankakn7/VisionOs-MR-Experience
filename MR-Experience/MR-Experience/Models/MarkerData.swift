//
//  MarkerData.swift
//  MR-Experience
//
//  Created by Christian Helbig on 14.06.24.
//

import Foundation

struct MarkerData: Codable {
    let timestamps: [String: Timestamp]
    let timelineElements: [String: TimelineElement]
    let mapElements: [String: MapElement]
}

struct Timestamp: Codable {
    let information: String
    let _3dpath: String
    let timeline_highlight: Int
    let map_content: Int
}

struct TimelineElement: Codable {
    let text: String
    let datetime: String
}

struct MapElement: Codable {
    let type: String
    let location: Location?
    let file: String?
}

struct Location: Codable {
    let lat: Double
    let long: Double
}
