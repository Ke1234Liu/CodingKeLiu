//
//  Response.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import Foundation

typealias Story = Response.ResponseData.Child.Story

// Json model
struct Response: Decodable {
    let data: ResponseData
    struct ResponseData: Decodable {
        let after: String
        let children: [Child]
        struct Child: Decodable {
            let data: Story
            struct Story: Decodable {
                let title: String?
                let thumbnailHeight: Int?
                let thumbnailWidth: Int?
                let thumbnail: String?
                let numComments: Int
                private enum CodingKeys: String, CodingKey {
                    case title
                    case thumbnailHeight = "thumbnail_height"
                    case thumbnailWidth = "thumbnail_width"
                    case thumbnail
                    case numComments = "num_comments"
                }
            }
        }
    }
}
