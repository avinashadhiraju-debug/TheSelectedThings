//
//  ProductModel.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

struct ProductModel: Identifiable, Equatable {
    var id: Int = 0
    var prodId: Int = 0
    var catId: Int = 0
    var brandId: Int = 0
    var typeId: Int = 0
    
    var name: String = ""
    var brandName: String = ""
    var designer: String = ""
    var detail: String = ""
    var image: String = ""
    var catName: String = ""
    var typeName: String = ""
    
    var price: Double = 0.0
    var isFav: Bool = false
    var avgRating: Int = 5
    var externalURL: String = ""
    var specifications: [String: String] = [:]
    var reviews: [ReviewModel] = []
    
    var unitValue: String = ""
    var unitName: String = ""

    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "prod_id") as? Int ?? 0
        self.prodId = dict.value(forKey: "prod_id") as? Int ?? 0
        self.catId = dict.value(forKey: "cat_id") as? Int ?? 0
        self.brandId = dict.value(forKey: "brand_id") as? Int ?? 0
        self.typeId = dict.value(forKey: "type_id") as? Int ?? 0
        self.isFav = dict.value(forKey: "is_fav") as? Int ?? 0 == 1
        
        self.name = dict.value(forKey: "name") as? String ?? ""
        self.brandName = dict.value(forKey: "brand_name") as? String ?? ""
        self.designer = dict.value(forKey: "designer") as? String ?? ""
        self.detail = dict.value(forKey: "detail") as? String ?? ""
        self.image = dict.value(forKey: "image") as? String ?? ""
        self.catName = dict.value(forKey: "cat_name") as? String ?? ""
        self.typeName = dict.value(forKey: "type_name") as? String ?? ""
        
        self.price = dict.value(forKey: "price") as? Double ?? 0.0
        self.avgRating = Int(dict.value(forKey: "avg_rating") as? Double ?? 5.0)
        self.externalURL = dict.value(forKey: "external_url") as? String ?? ""
        self.specifications = dict.value(forKey: "specifications") as? [String: String] ?? [:]
        
        self.unitValue = dict.value(forKey: "unit_value") as? String ?? ""
        self.unitName = dict.value(forKey: "unit_name") as? String ?? ""
        
        if let reviewDicts = dict.value(forKey: "reviews") as? [NSDictionary] {
            self.reviews = reviewDicts.map { ReviewModel(userName: $0["user_name"] as? String ?? "",
                                                         rating: $0["rating"] as? Int ?? 5,
                                                         date: $0["date"] as? String ?? "",
                                                         comment: $0["comment"] as? String ?? "") }
        }
    }
    
    // Designated manual initializer for static curated mock data
    init(id: Int, name: String, brandName: String, designer: String, detail: String, image: String, catName: String, typeName: String, price: Double, externalURL: String, specifications: [String: String], reviews: [ReviewModel]) {
        self.id = id
        self.prodId = id
        self.name = name
        self.brandName = brandName
        self.designer = designer
        self.detail = detail
        self.image = image
        self.catName = catName
        self.typeName = typeName
        self.price = price
        self.externalURL = externalURL
        self.specifications = specifications
        self.reviews = reviews
        self.avgRating = reviews.isEmpty ? 5 : Int(round(Double(reviews.map { $0.rating }.reduce(0, +)) / Double(reviews.count)))
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Core Luxury Lookbook fallback database when API / network is unavailable
    static let curatedProducts: [ProductModel] = [
        ProductModel(
            id: 1,
            name: "Eames Lounge Chair & Ottoman",
            brandName: "Herman Miller",
            designer: "Charles & Ray Eames",
            detail: "Originally released in 1956, the Eames Lounge Chair is widely considered one of the most significant furniture designs of the 20th century. Combining master craftsmanship with innovative molded plywood techniques, it offers unparalleled comfort and a luxurious design presence that matures beautifully over generations.",
            image: "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=800&auto=format&fit=crop",
            catName: "Furniture",
            typeName: "Lounge Seating",
            price: 7995.00,
            externalURL: "https://www.hermanmiller.com/products/seating/lounge-chairs-and-ottomans/eames-lounge-chair-and-ottoman/",
            specifications: [
                "Materials": "Molded Ash Plywood, Premium Leather, Die-cast Aluminum",
                "Dimensions": "32.75\" W x 32.75\" D x 32\" H",
                "Origin": "United States",
                "Warranty": "5 Years"
            ],
            reviews: [
                ReviewModel(userName: "Alexander V.", rating: 5, date: "May 12, 2026", comment: "The pinnacle of furniture design. The leather is exceptionally soft, and it serves as the absolute crown jewel of my study."),
                ReviewModel(userName: "Sophia L.", rating: 5, date: "Apr 28, 2026", comment: "A timeless masterpiece. Unbelievably comfortable, and the wood grain finishes are spectacular.")
            ]
        ),
        ProductModel(
            id: 2,
            name: "Leica Q3 Camera",
            brandName: "Leica",
            designer: "Leica Design Studio",
            detail: "The Leica Q3 represents a perfect fusion of classic mechanical engineering and cutting-edge digital technology. Featuring a breathtaking 60-megapixel full-frame sensor and the legendary Summilux 28mm f/1.7 ASPH lens, this compact camera offers exceptional resolving power, pristine aesthetics, and an unmatched tactile shooting experience.",
            image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop",
            catName: "Technology",
            typeName: "Cameras",
            price: 5995.00,
            externalURL: "https://leica-camera.com/en-US/photography/cameras/q/q3",
            specifications: [
                "Sensor": "60.3 MP Full-Frame CMOS",
                "Lens": "Summilux 28mm f/1.7 ASPH",
                "ISO Range": "50 - 100,000",
                "Weight": "743g",
                "Weather Sealing": "IP52 Certified"
            ],
            reviews: [
                ReviewModel(userName: "Marcus B.", rating: 5, date: "May 20, 2026", comment: "The image quality is staggering. Tactile controls make every shot feel intentional and artistic. Truly a masterpiece camera."),
                ReviewModel(userName: "Claire D.", rating: 5, date: "May 03, 2026", comment: "Sleek, powerful, and beautifully minimal. It has completely changed the way I document my travels.")
            ]
        ),
        ProductModel(
            id: 3,
            name: "OB-4 Magic Speaker",
            brandName: "teenage engineering",
            designer: "Teenage Engineering Studio",
            detail: "OB-4 is a high-fidelity portable loudspeaker featuring a four-driver configuration, high-efficiency Class D amplifiers, and an integrated 'tape' loop that continuously records everything you hear. With Bluetooth, line-in, FM radio, and innovative disk modes for interactive ambient sound manipulation, it is a playful instrument disguised as a premium speaker.",
            image: "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
            catName: "Audio",
            typeName: "Speakers",
            price: 649.00,
            externalURL: "https://teenage.engineering/store/ob-4/",
            specifications: [
                "Amplifiers": "2 x 38W Class D",
                "Frequency Range": "52 Hz - 25,000 Hz",
                "Battery Life": "Up to 72 Hours (Normal Vol)",
                "Connectivity": "Bluetooth LE, 3.5mm Jack, FM",
                "Tape Length": "2 Hours Rolling Memory"
            ],
            reviews: [
                ReviewModel(userName: "Jonas S.", rating: 5, date: "May 18, 2026", comment: "The tape rewind feature is incredibly addictive. Sound is crisp, punchy, and surprisingly wide. Teenage Engineering does it again."),
                ReviewModel(userName: "Elena M.", rating: 4, date: "May 10, 2026", comment: "Stunning minimalist design and fantastic battery life. A bit expensive, but the sheer joy of using it makes it highly worthwhile.")
            ]
        ),
        ProductModel(
            id: 4,
            name: "Akari 1A Table Lamp",
            brandName: "Vitra",
            designer: "Isamu Noguchi",
            detail: "Designed in 1951 by legendary Japanese-American artist Isamu Noguchi, the Akari Light Sculptures are handcrafted from traditional Washi paper and bamboo ribs. The Akari 1A provides a warm, soft, diffused glow that filters harsh electrical light, bringing natural beauty, warmth, and organic harmony to any modern interior space.",
            image: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
            catName: "Lighting",
            typeName: "Table Lamps",
            price: 450.00,
            externalURL: "https://www.vitra.com/en-us/product/akari-light-sculptures",
            specifications: [
                "Materials": "Washi Paper, Bamboo, Steel wire legs",
                "Socket": "E26/E27",
                "Handmade in": "Gifu, Japan",
                "Dimensions": "10\" W x 10\" D x 17\" H"
            ],
            reviews: [
                ReviewModel(userName: "Kenji T.", rating: 5, date: "May 14, 2026", comment: "It's more of a living sculpture than a simple lamp. The way it diffuses light creates an incredibly peaceful room ambiance."),
                ReviewModel(userName: "Emma H.", rating: 5, date: "Apr 15, 2026", comment: "Minimalist, organic, and elegant. It casting a beautiful, soft golden glow every evening. Absolutely iconic.")
            ]
        ),
        ProductModel(
            id: 5,
            name: "AW10 Watches",
            brandName: "Braun",
            designer: "Dietrich Lubs & Dieter Rams",
            detail: "First introduced in 1989, the Braun AW10 watch represents the epitome of functionalist watchmaking. Designed by Dietrich Lubs under Dieter Rams' philosophy of 'less, but better,' it features a clean layout, a high-contrast watch face with the signature yellow second hand, and a matte stainless steel case. A timeless statement of functional minimalism.",
            image: "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
            catName: "Timepieces",
            typeName: "Analog Watches",
            price: 220.00,
            externalURL: "https://www.braun-clocks.com/collections/watches",
            specifications: [
                "Movement": "3-Hand Quartz",
                "Water Resistance": "3 ATM (30m)",
                "Case Material": "Stainless Steel",
                "Strap": "Premium Black Leather",
                "Case Diameter": "33mm"
            ],
            reviews: [
                ReviewModel(userName: "Dieter F.", rating: 5, date: "May 22, 2026", comment: "A brilliant tribute to Rams' design ethos. It is extremely light, legible, and represents timeless elegance."),
                ReviewModel(userName: "Lucas G.", rating: 4, date: "May 02, 2026", comment: "Extremely understated and elegant watch. Fits perfectly under a shirt cuff. A design classic.")
            ]
        ),
        ProductModel(
            id: 6,
            name: "Wooden Dolls No. 1",
            brandName: "Vitra",
            designer: "Alexander Girard",
            detail: "Alexander Girard designed the Wooden Dolls in 1953 for his own home in Santa Fe. These whimsical figures, inspired by his love for folk art and vibrant colors, are part playful toy and part decorative sculpture. Handcrafted and hand-painted in solid fir wood, each doll is a unique collector's piece that injects personality and mid-century character.",
            image: "https://images.unsplash.com/photo-1558882224-cca166733360?q=80&w=800&auto=format&fit=crop",
            catName: "Objects",
            typeName: "Home Accessories",
            price: 155.00,
            externalURL: "https://www.vitra.com/en-us/product/wooden-dolls",
            specifications: [
                "Material": "Solid Fir Wood, Hand-Painted",
                "Packaging": "High-Quality wooden gift box",
                "Origin": "Designed in 1953",
                "Dimensions": "2\" W x 1.8\" D x 10.8\" H"
            ],
            reviews: [
                ReviewModel(userName: "Isabella P.", rating: 5, date: "May 08, 2026", comment: "Each doll is hand-painted, meaning no two are identical. It brings so much warmth and artistic playfulness to our living room bookshelf."),
                ReviewModel(userName: "Alistair C.", rating: 5, date: "Apr 11, 2026", comment: "Beautifully packaged, well-crafted, and a stellar collector's item for mid-century modern design enthusiasts.")
            ]
        )
    ]
}

struct ReviewModel: Identifiable, Equatable {
    var id = UUID()
    var userName: String = ""
    var rating: Int = 0
    var date: String = ""
    var comment: String = ""
    
    init(userName: String, rating: Int, date: String, comment: String) {
        self.userName = userName
        self.rating = rating
        self.date = date
        self.comment = comment
    }
}
