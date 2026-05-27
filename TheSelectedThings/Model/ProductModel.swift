//
//  ProductModel.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct ProductModel: Identifiable, Equatable {
    var id: Int = 0
    var prodId: Int = 0
    
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

    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "prod_id") as? Int ?? 0
        self.prodId = dict.value(forKey: "prod_id") as? Int ?? 0
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
    static let curatedProducts: [ProductModel] = {
        guard let data = ProductsFallback.jsonString.data(using: .utf8) else {
            return []
        }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                return jsonArray.map { ProductModel(dict: $0) }
            }
        } catch {
            print("Failed to parse fallback products: \(error)")
        }
        return []
    }()
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


struct ProductsFallback {
    static let jsonString: String = #"""
[
    {
        "prod_id": 1,
        "name": "Eames Lounge Chair & Ottoman",
        "brand_name": "Herman Miller",
        "designer": "Charles & Ray Eames",
        "detail": "Originally released in 1956, the Eames Lounge Chair is widely considered one of the most significant furniture designs of the 20th century. Combining master craftsmanship with innovative molded plywood techniques, it offers unparalleled comfort and a luxurious design presence that matures beautifully over generations.",
        "image": "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Lounge Seating",
        "price": 7995.0,
        "avg_rating": 5.0,
        "external_url": "https://www.hermanmiller.com/products/seating/lounge-chairs-and-ottomans/eames-lounge-chair-and-ottoman/",
        "specifications": {
            "Materials": "Molded Ash Plywood, Premium Leather, Die-cast Aluminum",
            "Dimensions": "32.75\\",
            "Origin": "United States",
            "Warranty": "5 Years"
        },
        "reviews": [
            {
                "user_name": "Alexander V.",
                "rating": 5,
                "date": "May 12, 2026",
                "comment": "The pinnacle of furniture design. The leather is exceptionally soft, and it serves as the absolute crown jewel of my study."
            },
            {
                "user_name": "Sophia L.",
                "rating": 5,
                "date": "Apr 28, 2026",
                "comment": "A timeless masterpiece. Unbelievably comfortable, and the wood grain finishes are spectacular."
            }
        ]
    },
    {
        "prod_id": 2,
        "name": "LC4 Chaise Longue",
        "brand_name": "Cassina",
        "designer": "Le Corbusier, P. Jeanneret, C. Perriand",
        "detail": "Designed in 1928, the LC4 is the definitive chaise longue. Dubbed the ultimate 'relaxing machine,' it mirrors the natural curves of the human body in repose, supported by a polished chrome-plated steel frame and an elegant black leather headrest.",
        "image": "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Chaise Longues",
        "price": 5450.0,
        "avg_rating": 5.0,
        "external_url": "https://www.cassina.com/en/collection/chaises-longues/lc4",
        "specifications": {
            "Structure": "Polished Chrome Steel, Steel Base",
            "Upholstery": "Premium Black Leather, Tricolor Hide",
            "Dimensions": "22.0\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Marc D.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "Absolute perfection in ergonomics. The chrome reflection and leather smell are incredible."
            }
        ]
    },
    {
        "prod_id": 3,
        "name": "Barcelona Chair",
        "brand_name": "Knoll",
        "designer": "Ludwig Mies van der Rohe",
        "detail": "One of the most recognized objects of the last century, and an icon of the modern movement, the Barcelona Chair exudes a simple elegance. Mies van der Rohe's masterpiece is hand-buffed and hand-upholstered with 40 individual panels.",
        "image": "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Lounge Chairs",
        "price": 7140.0,
        "avg_rating": 5.0,
        "external_url": "https://www.knoll.com/product/barcelona-chair",
        "specifications": {
            "Frame": "Chrome-plated Spring Steel",
            "Leather": "Spinneybeck Volo Leather",
            "Dimensions": "30\\",
            "Origin": "United States"
        },
        "reviews": [
            {
                "user_name": "Helena K.",
                "rating": 5,
                "date": "May 10, 2026",
                "comment": "Stately and surprisingly comfortable. It acts as an anchor piece for our modern lobby."
            }
        ]
    },
    {
        "prod_id": 4,
        "name": "Womb Chair",
        "brand_name": "Knoll",
        "designer": "Eero Saarinen",
        "detail": "Eero Saarinen designed the groundbreaking Womb Chair in 1946 to satisfy a request for a chair that 'was like a basket full of pillows\u2014something I could really curl up in.' This mid-century classic offers cozy psychological and physical comfort.",
        "image": "https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Lounge Chairs",
        "price": 6250.0,
        "avg_rating": 5.0,
        "external_url": "https://www.knoll.com/product/womb-chair",
        "specifications": {
            "Shell": "Fiberglass reinforced polyurethane",
            "Upholstery": "Premium Boucl\u00e9 Fabric",
            "Base": "Polished Chrome Steel legs",
            "Dimensions": "40\\"
        },
        "reviews": [
            {
                "user_name": "Chloe T.",
                "rating": 5,
                "date": "May 09, 2026",
                "comment": "Like being hugged by a cloud. The boucl\u00e9 texture is wonderful."
            }
        ]
    },
    {
        "prod_id": 5,
        "name": "Wassily Chair",
        "brand_name": "Knoll",
        "designer": "Marcel Breuer",
        "detail": "Inspired by the tubular steel frame of a bicycle, Marcel Breuer's 1925 Wassily Chair represents a breakthrough in material design. By stripping away traditional padding, it uses tensioned leather straps for a minimalist, structural form.",
        "image": "https://images.unsplash.com/photo-1503602642458-232111445657?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Lounge Chairs",
        "price": 3380.0,
        "avg_rating": 5.0,
        "external_url": "https://www.knoll.com/product/wassily-chair",
        "specifications": {
            "Frame": "Seamless Tubular Steel",
            "Straps": "Spinneybeck Belting Leather",
            "Dimensions": "31\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Hans L.",
                "rating": 5,
                "date": "May 01, 2026",
                "comment": "An architectural marvel. Extremely light and strong, yet feels perfectly suspended."
            }
        ]
    },
    {
        "prod_id": 6,
        "name": "Standard Chair",
        "brand_name": "Vitra",
        "designer": "Jean Prouv\u00e9",
        "detail": "Designed in 1934, Prouv\u00e9's Standard Chair shows how loads are distributed in a seating object. While thin steel tubes are used for the front legs as they bear less weight, the back legs are made of hollow steel sections to direct weight to the floor.",
        "image": "https://images.unsplash.com/photo-1506898667547-42e22a46e125?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Dining Chairs",
        "price": 925.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/standard",
        "specifications": {
            "Seat & Back": "Natural Oak or Walnut Plywood",
            "Base": "Bent Sheet Steel, Powder-Coated",
            "Dimensions": "16.5\\",
            "Origin": "Germany"
        },
        "reviews": [
            {
                "user_name": "Antoine R.",
                "rating": 5,
                "date": "Apr 22, 2026",
                "comment": "Engineering at its finest. The contrast between structural metal and warm wood is sublime."
            }
        ]
    },
    {
        "prod_id": 7,
        "name": "Series 7 Chair",
        "brand_name": "Fritz Hansen",
        "designer": "Arne Jacobsen",
        "detail": "The Series 7 designed by Arne Jacobsen in 1955 is a masterpiece of pressure-molded veneer. Its unique shape is understated and highly versatile, fitting seamlessly into dining rooms, workspaces, and creative studios globally.",
        "image": "https://images.unsplash.com/photo-1517705008128-361805f42e86?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Dining Chairs",
        "price": 695.0,
        "avg_rating": 5.0,
        "external_url": "https://www.fritzhansen.com/en/categories/by-designer/arne-jacobsen/series-7",
        "specifications": {
            "Veneer": "Pressure-Molded Ash Plywood",
            "Base": "Chromed Steel Tubes",
            "Stackable": "Up to 12 chairs",
            "Origin": "Denmark"
        },
        "reviews": [
            {
                "user_name": "Mette S.",
                "rating": 5,
                "date": "May 11, 2026",
                "comment": "An elegant, lightweight dining staple. Danish design at its absolute best."
            }
        ]
    },
    {
        "prod_id": 8,
        "name": "Wishbone Chair (CH24)",
        "brand_name": "Carl Hansen & S\u00f8n",
        "designer": "Hans J. Wegner",
        "detail": "With a form that is both light and welcoming, the 1949 CH24 Wishbone Chair is a staple of mid-century Scandinavian dining. It features a hand-woven paper cord seat that takes a skilled craftsman about an hour to weave.",
        "image": "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Dining Chairs",
        "price": 895.0,
        "avg_rating": 5.0,
        "external_url": "https://www.carlhansen.com/en/collection/chairs/dining-chairs/ch24",
        "specifications": {
            "Frame": "Solid White Soap-treated Oak",
            "Seat": "120 meters of Paper Cord",
            "Dimensions": "21.6\\",
            "Origin": "Denmark"
        },
        "reviews": [
            {
                "user_name": "Frederik B.",
                "rating": 5,
                "date": "May 15, 2026",
                "comment": "Comfortable and beautifully crafted. The paper cord seat feels alive and changes nicely over time."
            }
        ]
    },
    {
        "prod_id": 9,
        "name": "Togo Sofa",
        "brand_name": "Ligne Roset",
        "designer": "Michel Ducaroy",
        "detail": "A Ligne Roset classic, Michel Ducaroy's Togo is the ultimate in comfort and style. Since 1973, this modular, all-foam seating collection has been a favorite for casual lounging, offering an inviting, plush aesthetic.",
        "image": "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Modular Sofas",
        "price": 3850.0,
        "avg_rating": 5.0,
        "external_url": "https://www.ligne-roset.com/us/modele/living/sofas/togo/37",
        "specifications": {
            "Structure": "3 multiple-density polyether foam zones",
            "Upholstery": "Premium Alcantara Fabric",
            "Dimensions": "51.5\\",
            "Origin": "France"
        },
        "reviews": [
            {
                "user_name": "Julian P.",
                "rating": 5,
                "date": "May 25, 2026",
                "comment": "Incredibly cozy and low-slung. The focal point of our casual listening room."
            }
        ]
    },
    {
        "prod_id": 10,
        "name": "Panton Chair",
        "brand_name": "Vitra",
        "designer": "Verner Panton",
        "detail": "Developed in 1967, the Panton Chair was the first single-piece plastic cantilever chair. With its organic silhouette and expressive curves, it is an iconic masterpiece of space-age, modern interior design.",
        "image": "https://images.unsplash.com/photo-1580481072645-022f9a6dbf27?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Furniture",
        "type_name": "Cantilever Chairs",
        "price": 495.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/panton-chair",
        "specifications": {
            "Material": "Dyed-through Polypropylene",
            "Finish": "Matte finish",
            "Dimensions": "19.75\\",
            "Origin": "Germany"
        },
        "reviews": [
            {
                "user_name": "Lars N.",
                "rating": 5,
                "date": "May 06, 2026",
                "comment": "An absolute design sculptural wonder. Looks great indoors or outdoors!"
            }
        ]
    },
    {
        "prod_id": 11,
        "name": "Akari 1A Table Lamp",
        "brand_name": "Vitra",
        "designer": "Isamu Noguchi",
        "detail": "Designed in 1951 by legendary Japanese-American artist Isamu Noguchi, the Akari Light Sculptures are handcrafted from traditional Washi paper and bamboo ribs. The Akari 1A provides a warm, soft, diffused glow that filters harsh electrical light, bringing natural beauty, warmth, and organic harmony to any modern interior space.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Table Lamps",
        "price": 450.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/akari-light-sculptures",
        "specifications": {
            "Materials": "Washi Paper, Bamboo, Steel wire legs",
            "Socket": "E26/E27",
            "Handmade in": "Gifu, Japan",
            "Dimensions": "10\\"
        },
        "reviews": [
            {
                "user_name": "Kenji T.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "It's more of a living sculpture than a simple lamp. The way it diffuses light creates an incredibly peaceful room ambiance."
            },
            {
                "user_name": "Emma H.",
                "rating": 5,
                "date": "Apr 15, 2026",
                "comment": "Minimalist, organic, and elegant. It casting a beautiful, soft golden glow every evening. Absolutely iconic."
            }
        ]
    },
    {
        "prod_id": 12,
        "name": "Arco Floor Lamp",
        "brand_name": "Flos",
        "designer": "Achille & Pier Giacomo Castiglioni",
        "detail": "Designed in 1962, the Arco Floor Lamp is a masterpiece of form and function. It features a solid white Carrara marble pedestal and a satin-finish stainless steel telescopic arch that suspends a polished aluminum dome.",
        "image": "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Floor Lamps",
        "price": 3495.0,
        "avg_rating": 5.0,
        "external_url": "https://flos.com/en/us/arco/p-F0300000",
        "specifications": {
            "Base": "Solid Carrara Marble (approx. 143 lbs)",
            "Arch": "Satin-Finish Stainless Steel",
            "Height": "95\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Giovanni M.",
                "rating": 5,
                "date": "May 17, 2026",
                "comment": "The marble base is heavy but gorgeous. Suspends light perfectly over my table."
            }
        ]
    },
    {
        "prod_id": 13,
        "name": "Snoopy Table Lamp",
        "brand_name": "Flos",
        "designer": "Achille & Pier Giacomo Castiglioni",
        "detail": "First introduced in 1967, the Snoopy Table Lamp is a playful homage to the beloved cartoon character. Featuring a high-gloss black enameled metal reflector and a thick, cylindrical white Carrara marble base, it provides beautiful direct illumination.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Table Lamps",
        "price": 1395.0,
        "avg_rating": 5.0,
        "external_url": "https://flos.com/en/us/snoopy/p-F7100030",
        "specifications": {
            "Base": "Cylindrical White Carrara Marble",
            "Reflector": "Enameled Black Metal",
            "Dimmer": "Integrated touch dimmer",
            "Dimensions": "15.5\\"
        },
        "reviews": [
            {
                "user_name": "Clara P.",
                "rating": 5,
                "date": "May 19, 2026",
                "comment": "Playful yet refined. The marble base is exceptionally high quality and solid."
            }
        ]
    },
    {
        "prod_id": 14,
        "name": "Taccia Table Lamp",
        "brand_name": "Flos",
        "designer": "Achille & Pier Giacomo Castiglioni",
        "detail": "The 1962 Taccia Lamp resembles an industrial column with a hand-blown glass bowl atop. It provides indirect, reflected light, featuring an aluminum reflector painted gloss white on the outside and matte white on the inside.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Table Lamps",
        "price": 2995.0,
        "avg_rating": 5.0,
        "external_url": "https://flos.com/en/us/taccia/p-F6602004",
        "specifications": {
            "Bowl": "Hand-blown Clear Glass",
            "Base": "Extruded Aluminum Column",
            "Reflector": "Spun Aluminum",
            "Dimensions": "19.5\\"
        },
        "reviews": [
            {
                "user_name": "Roger F.",
                "rating": 5,
                "date": "May 22, 2026",
                "comment": "Stunning scale and glow. It's like having a miniature sun bouncing off hand-blown glass."
            }
        ]
    },
    {
        "prod_id": 15,
        "name": "Nesso Table Lamp",
        "brand_name": "Artemide",
        "designer": "Giancarlo Mattioli",
        "detail": "Designed in 1965, the Nesso Table Lamp is an icon of Italian space-age design. Its expressive mushroom shape diffuses a warm, direct and indirect orange light, injecting vintage charm into modern interiors.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Table Lamps",
        "price": 425.0,
        "avg_rating": 5.0,
        "external_url": "https://www.artemide.com/en/subfamily/1853610/nesso",
        "specifications": {
            "Material": "ABS Thermoplastic Resin",
            "Light source": "4 x E12 Max 25W bulbs",
            "Dimensions": "21.25\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Stefano T.",
                "rating": 5,
                "date": "May 12, 2026",
                "comment": "The orange glow is incredibly atmospheric. A fantastic retro piece."
            }
        ]
    },
    {
        "prod_id": 16,
        "name": "Parentesi Pendant Lamp",
        "brand_name": "Flos",
        "designer": "Achille Castiglioni & Pio Manz\u00f9",
        "detail": "Winner of the Compasso d'Oro in 1979, the Parentesi provides direct light by sliding a shaped nickel-plated steel tube on a floor-to-ceiling steel cable. Pure genius in minimal industrial design.",
        "image": "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Pendant Lamps",
        "price": 595.0,
        "avg_rating": 5.0,
        "external_url": "https://flos.com/en/us/parentesi/p-F5600030",
        "specifications": {
            "Cable": "Steel wire, 157\\",
            "Tube": "Bent Steel, Liquid Varnished",
            "Weight": "Cast-iron base wrapped in protective rubber"
        },
        "reviews": [
            {
                "user_name": "Mateo R.",
                "rating": 5,
                "date": "May 10, 2026",
                "comment": "Incredibly clever. You can adjust the height and angle with a simple slide."
            }
        ]
    },
    {
        "prod_id": 17,
        "name": "PH 5 Pendant Lamp",
        "brand_name": "Louis Poulsen",
        "designer": "Poul Henningsen",
        "detail": "Poul Henningsen designed the PH 5 in 1958 in response to constant changes to the shape and size of incandescent bulbs. Its innovative three-shade system redirects light downwards and outwards, completely eliminating glare.",
        "image": "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Pendant Lamps",
        "price": 1195.0,
        "avg_rating": 5.0,
        "external_url": "https://www.louispoulsen.com/en-us/catalog/private/pendants/ph-5",
        "specifications": {
            "Material": "Spun Aluminum Shades",
            "Anti-glare ring": "Spun copper or blue aluminum",
            "Dimensions": "19.7\\",
            "Origin": "Denmark"
        },
        "reviews": [
            {
                "user_name": "Astrid G.",
                "rating": 5,
                "date": "May 08, 2026",
                "comment": "The soft distribution of light is unparalleled. No glare whatsoever."
            }
        ]
    },
    {
        "prod_id": 18,
        "name": "Flowerpot VP1 Pendant",
        "brand_name": "&Tradition",
        "designer": "Verner Panton",
        "detail": "The Flowerpot VP1 represents the peace-loving Flower Power generation of the late 1960s. Composed of two semi-circular spheres facing each other, it is a timeless classic that brings soft, colorful elegance to any dining or kitchen space.",
        "image": "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Pendant Lamps",
        "price": 375.0,
        "avg_rating": 5.0,
        "external_url": "https://www.andtradition.com/products/flowerpot-vp1",
        "specifications": {
            "Material": "Lacquered Metal, 3m fabric cord",
            "Dimensions": "9.1\\",
            "Origin": "Denmark"
        },
        "reviews": [
            {
                "user_name": "Nina L.",
                "rating": 5,
                "date": "Apr 30, 2026",
                "comment": "A simple, delightful pop of modern color. Perfect over our kitchen island."
            }
        ]
    },
    {
        "prod_id": 19,
        "name": "Atollo Metal Table Lamp",
        "brand_name": "Oluce",
        "designer": "Vico Magistretti",
        "detail": "Awarded the Compasso d'Oro in 1979, the Atollo has completely revolutionized the table lamp. Composed of a cylinder, a cone, and a hemisphere, it is an abstract sculpture that projects a warm, beautiful indirect ambient light.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Table Lamps",
        "price": 1850.0,
        "avg_rating": 5.0,
        "external_url": "https://www.oluce.com/en/product/atollo-239/",
        "specifications": {
            "Material": "Opaline Blown Glass or Lacquered Metal",
            "Finishes": "Satin Gold, Matte Black, White",
            "Dimensions": "15\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Roberto C.",
                "rating": 5,
                "date": "May 24, 2026",
                "comment": "The geometric shapes create a spectacular visual contrast. The gold finish is absolutely luxurious."
            }
        ]
    },
    {
        "prod_id": 20,
        "name": "Bellhop Table Lamp",
        "brand_name": "Flos",
        "designer": "Edward Barber & Jay Osgerby",
        "detail": "Originally designed for the London Design Museum restaurant, the Bellhop is a rechargeable, portable tabletop lamp that acts as a modern-day candle. It offers up to 24 hours of warm, glare-free, direct illumination.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Lighting",
        "type_name": "Portable Lamps",
        "price": 325.0,
        "avg_rating": 5.0,
        "external_url": "https://flos.com/en/us/bellhop-portable/p-F1060009",
        "specifications": {
            "Battery Life": "Up to 24 Hours",
            "Charging": "USB-C charging cable",
            "Dimmer": "4-step touch dimmer switch",
            "Dimensions": "4.9\\"
        },
        "reviews": [
            {
                "user_name": "Chloe M.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "Super cute and easy to move around. We use it for cozy outdoor dinners on the terrace."
            }
        ]
    },
    {
        "prod_id": 21,
        "name": "OB-4 Magic Speaker",
        "brand_name": "teenage engineering",
        "designer": "Teenage Engineering Studio",
        "detail": "OB-4 is a high-fidelity portable loudspeaker featuring a four-driver configuration, high-efficiency Class D amplifiers, and an integrated 'tape' loop that continuously records everything you hear. With Bluetooth, line-in, FM radio, and innovative disk modes for interactive ambient sound manipulation, it is a playful instrument disguised as a premium speaker.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Speakers",
        "price": 649.0,
        "avg_rating": 5.0,
        "external_url": "https://teenage.engineering/store/ob-4/",
        "specifications": {
            "Amplifiers": "2 x 38W Class D",
            "Frequency Range": "52 Hz - 25,000 Hz",
            "Battery Life": "Up to 72 Hours (Normal Vol)",
            "Connectivity": "Bluetooth LE, 3.5mm Jack, FM",
            "Tape Length": "2 Hours Rolling Memory"
        },
        "reviews": [
            {
                "user_name": "Jonas S.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "The tape rewind feature is incredibly addictive. Sound is crisp, punchy, and surprisingly wide. Teenage Engineering does it again."
            },
            {
                "user_name": "Elena M.",
                "rating": 4,
                "date": "May 10, 2026",
                "comment": "Stunning minimalist design and fantastic battery life. A bit expensive, but the sheer joy of using it makes it highly worthwhile."
            }
        ]
    },
    {
        "prod_id": 22,
        "name": "Beosound A9",
        "brand_name": "Bang & Olufsen",
        "designer": "\u00d8ivind Alexander Slaatto",
        "detail": "A design icon masquerading as custom furniture, the Beosound A9 fills any large room with high-fidelity, spacious Bang & Olufsen signature sound. It features gorgeous oak legs, a Kvadrat designer wool cover, and capacitive touch control.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Speakers",
        "price": 3999.0,
        "avg_rating": 5.0,
        "external_url": "https://www.bang-olufsen.com/en/us/speakers/beosound-a9",
        "specifications": {
            "Amplifiers": "1 x 400W bass, 2 x 200W mid, 2 x 200W full, 2 x 150W treble",
            "Room Calibration": "Active Room Compensation",
            "Material": "Oak Wood, Aluminum, Kvadrat Fabric",
            "Weight": "14.7 kg"
        },
        "reviews": [
            {
                "user_name": "Sebastian H.",
                "rating": 5,
                "date": "May 16, 2026",
                "comment": "Sounds like a live concert in my living room. Truly beautiful sculptural piece."
            }
        ]
    },
    {
        "prod_id": 23,
        "name": "Beoplay H95",
        "brand_name": "Bang & Olufsen",
        "designer": "MNML",
        "detail": "Crafted for the ultimate travel experience, Beoplay H95 features custom titanium drivers and active noise cancellation. With up to 38 hours of playtime, it represents the absolute pinnacle of luxury over-ear headphones.",
        "image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Headphones",
        "price": 999.0,
        "avg_rating": 5.0,
        "external_url": "https://www.bang-olufsen.com/en/us/headphones/beoplay-h95",
        "specifications": {
            "Drivers": "40mm Electro-dynamic Titanium",
            "Noise Cancellation": "Adaptive Active ANC",
            "Battery Life": "Up to 38 Hours with ANC",
            "Case": "Premium Aluminum Hard Case",
            "Weight": "323g"
        },
        "reviews": [
            {
                "user_name": "David K.",
                "rating": 5,
                "date": "May 20, 2026",
                "comment": "Unparalleled luxurious comfort. The lambskin leather and aluminum dials are exceptional."
            }
        ]
    },
    {
        "prod_id": 24,
        "name": "Braun TP 1 Receiver",
        "brand_name": "Braun",
        "designer": "Dieter Rams",
        "detail": "First introduced in 1959, the Braun TP 1 is a legendary portable radio and phonograph combination designed by Dieter Rams. Combining highly functionalist aesthetics with physical compactness, it represents a core milestone of Rams' 'less, but better' tenet.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Receivers",
        "price": 1250.0,
        "avg_rating": 5.0,
        "external_url": "https://www.braun-clocks.com",
        "specifications": {
            "Cabinet": "Sheet steel with PVC coating",
            "Controls": "Anodized Aluminum knobs",
            "Turntable Speed": "45 RPM",
            "Power": "6V Battery pack"
        },
        "reviews": [
            {
                "user_name": "Friedrich W.",
                "rating": 5,
                "date": "May 08, 2026",
                "comment": "A brilliant piece of industrial design history. An inspiration to look at every single day."
            }
        ]
    },
    {
        "prod_id": 25,
        "name": "Syng Cell Alpha",
        "brand_name": "Syng",
        "designer": "Christopher Stringer",
        "detail": "Designed by former long-time Apple industrial designer Christopher Stringer, the Syng Cell Alpha is the world's first triphonic speaker. It maps sound to your physical space to create a completely realistic, three-dimensional acoustic experience.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Speakers",
        "price": 1799.0,
        "avg_rating": 5.0,
        "external_url": "https://syngspace.com/products/cell-alpha",
        "specifications": {
            "Drivers": "Two opposed subwoofers, Triphone element",
            "Microphones": "3 built-in for room calibration",
            "Connectivity": "Wi-Fi, AirPlay 2, Spotify Connect, USB-C",
            "Height": "11.8\\"
        },
        "reviews": [
            {
                "user_name": "Julian V.",
                "rating": 5,
                "date": "May 15, 2026",
                "comment": "The soundstage is uncanny. It feels like the musicians are physically in the room."
            }
        ]
    },
    {
        "prod_id": 26,
        "name": "OP-1 Field",
        "brand_name": "teenage engineering",
        "designer": "Teenage Engineering Studio",
        "detail": "The OP-1 Field is the culmination of a decade of development. Featuring an ultra-slim aluminum housing, a high-resolution color screen, Bluetooth MIDI, and 24 hours of battery life, it is the ultimate portable synthesizer and workstation.",
        "image": "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Synthesizers",
        "price": 1999.0,
        "avg_rating": 5.0,
        "external_url": "https://teenage.engineering/store/op-1-field/",
        "specifications": {
            "Profile": "Ultra-thin Anodized Aluminum",
            "Display": "High-Res Flush AMOLED",
            "Synth Engines": "Over 12 unique engines",
            "Tape Tracks": "4-track tape recorder, multiple formats"
        },
        "reviews": [
            {
                "user_name": "Christian P.",
                "rating": 5,
                "date": "May 21, 2026",
                "comment": "Exquisite industrial design. Synthesizer, sampler, tape recorder\u2014it's a magic box of infinite creativity."
            }
        ]
    },
    {
        "prod_id": 27,
        "name": "Linn Sondek LP12 Turntable",
        "brand_name": "Linn",
        "designer": "Ivor Tiefenbrun",
        "detail": "Introduced in 1972, the Linn Sondek LP12 is one of the most famous turntables in audio history. Handcrafted in Scotland, its suspended sub-chassis and ultra-quiet belt-drive provide stunning analog warm playback.",
        "image": "https://images.unsplash.com/photo-1603048588665-791ca8aea617?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Turntables",
        "price": 4300.0,
        "avg_rating": 5.0,
        "external_url": "https://www.linn.co.uk/turntables/sondek-lp12",
        "specifications": {
            "Sub-chassis": "Suspended steel assembly",
            "Plinth": "Solid wood (Oak, Cherry, Walnut)",
            "Speed": "33.3 / 45 RPM",
            "Origin": "Glasgow, Scotland"
        },
        "reviews": [
            {
                "user_name": "Alistair M.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "Analog audio perfection. Matured beautifully over decades and still upgradeable."
            }
        ]
    },
    {
        "prod_id": 28,
        "name": "JBL L100 Classic",
        "brand_name": "JBL",
        "designer": "Chris Hagen",
        "detail": "A modern reimagining of the best-selling JBL loudspeaker of all time, the L100 Classic features a striking Quadrex foam grille, a walnut wood veneer cabinet, and iconic high-performance titanium dome tweeters.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Speakers",
        "price": 4400.0,
        "avg_rating": 5.0,
        "external_url": "https://www.jbl.com/home-audio/L100+CLASSIC.html",
        "specifications": {
            "Grille": "Iconic Quadrex Foam (Orange, Blue, Black)",
            "Cabinet": "Walnut Wood Veneer",
            "Woofer": "12-inch pure pulp cone woofer",
            "Weight": "26.7 kg"
        },
        "reviews": [
            {
                "user_name": "Thomas B.",
                "rating": 5,
                "date": "Apr 29, 2026",
                "comment": "Dynamic, loud, and looks incredibly cool. The orange foam grille is stunning."
            }
        ]
    },
    {
        "prod_id": 29,
        "name": "Sennheiser HD 800 S",
        "brand_name": "Sennheiser",
        "designer": "Sennheiser Design",
        "detail": "The HD 800 S represents the absolute peak of audiophile reference headphones. Handcrafted in Germany, its open-back design and massive 56mm ring radiator drivers deliver the widest soundstage in the industry.",
        "image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Headphones",
        "price": 1799.0,
        "avg_rating": 5.0,
        "external_url": "https://www.sennheiser-hearing.com/en-US/p/hd-800-s/",
        "specifications": {
            "Driver": "56mm Ring Radiator",
            "Design": "Circumaural, Open-Back",
            "Frequency Response": "4 Hz - 51,000 Hz",
            "Origin": "Germany"
        },
        "reviews": [
            {
                "user_name": "Arthur S.",
                "rating": 5,
                "date": "May 12, 2026",
                "comment": "Feels like speakers in a perfectly treated room. The resolution is mind-boggling."
            }
        ]
    },
    {
        "prod_id": 30,
        "name": "Naim Mu-so 2nd Gen",
        "brand_name": "Naim Audio",
        "designer": "Naim Design Team",
        "detail": "The Mu-so 2nd Generation is the successor to the multi-award-winning Mu-so wireless music system. Re-engineered for high performance by Naim's experts in Salisbury, England, it features a premium burnished aluminum casing.",
        "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Audio",
        "type_name": "Speakers",
        "price": 1799.0,
        "avg_rating": 5.0,
        "external_url": "https://www.naimaudio.com/mu-so",
        "specifications": {
            "Amplifiers": "450W Class D",
            "Processor": "Multicore 16x faster DSP",
            "Material": "Burnished Anodized Aluminum",
            "Dimensions": "24.7\\"
        },
        "reviews": [
            {
                "user_name": "Ian T.",
                "rating": 5,
                "date": "May 06, 2026",
                "comment": "Powerful, room-filling sound with a gorgeous dial that lights up as your hand approaches."
            }
        ]
    },
    {
        "prod_id": 31,
        "name": "Leica Q3 Camera",
        "brand_name": "Leica",
        "designer": "Leica Design Studio",
        "detail": "The Leica Q3 represents a perfect fusion of classic mechanical engineering and cutting-edge digital technology. Featuring a breathtaking 60-megapixel full-frame sensor and the legendary Summilux 28mm f/1.7 ASPH lens, this compact camera offers exceptional resolving power, pristine aesthetics, and an unmatched tactile shooting experience.",
        "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Cameras",
        "price": 5995.0,
        "avg_rating": 5.0,
        "external_url": "https://leica-camera.com/en-US/photography/cameras/q/q3",
        "specifications": {
            "Sensor": "60.3 MP Full-Frame CMOS",
            "Lens": "Summilux 28mm f/1.7 ASPH",
            "ISO Range": "50 - 100,000",
            "Weight": "743g",
            "Weather Sealing": "IP52 Certified"
        },
        "reviews": [
            {
                "user_name": "Marcus B.",
                "rating": 5,
                "date": "May 20, 2026",
                "comment": "The image quality is staggering. Tactile controls make every shot feel intentional and artistic. Truly a masterpiece camera."
            },
            {
                "user_name": "Claire D.",
                "rating": 5,
                "date": "May 03, 2026",
                "comment": "Sleek, powerful, and beautifully minimal. It has completely changed the way I document my travels."
            }
        ]
    },
    {
        "prod_id": 32,
        "name": "MacBook Pro Space Black",
        "brand_name": "Apple",
        "designer": "Apple Industrial Design Team",
        "detail": "Constructed from premium, recycled aluminum, the MacBook Pro features Apple's M3 Max chip and a stunning Liquid Retina XDR screen. The gorgeous anodized Space Black finish features a breakthrough dark surface chemistry that reduces fingerprints.",
        "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Laptops",
        "price": 3499.0,
        "avg_rating": 5.0,
        "external_url": "https://www.apple.com/macbook-pro/",
        "specifications": {
            "Processor": "Apple M3 Max Chip (16-core CPU)",
            "Memory": "48GB Unified RAM",
            "Display": "16.2-inch Liquid Retina XDR",
            "Finish": "Anodized Space Black"
        },
        "reviews": [
            {
                "user_name": "Kevin L.",
                "rating": 5,
                "date": "May 19, 2026",
                "comment": "Absolute speed demon. The screen is breathtaking, and the black finish looks incredibly professional."
            }
        ]
    },
    {
        "prod_id": 33,
        "name": "Hasselblad X2D 100C",
        "brand_name": "Hasselblad",
        "designer": "Hasselblad Design Team",
        "detail": "The flagship medium format mirrorless camera, the X2D 100C features a 100-megapixel back-illuminated CMOS sensor. With a built-in 1TB SSD and a body crafted from a solid block of aluminum, it is a tool of pure luxury and unmatched resolving power.",
        "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Cameras",
        "price": 8199.0,
        "avg_rating": 5.0,
        "external_url": "https://www.hasselblad.com/x-system/x2d-100c/",
        "specifications": {
            "Sensor": "100 MP Medium Format BSI CMOS",
            "Storage": "Built-in 1TB SSD",
            "Stabilization": "5-axis 7-stop IBIS",
            "Weight": "895g"
        },
        "reviews": [
            {
                "user_name": "Erik J.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "The color rendering is natural and incredibly deep. A massive upgrade for medium format shooters."
            }
        ]
    },
    {
        "prod_id": 34,
        "name": "Dyson 360 Vis Nav",
        "brand_name": "Dyson",
        "designer": "Jake Dyson",
        "detail": "The most powerful robot vacuum on the market, the 360 Vis Nav features a 360-degree vision system and a custom Dyson Hyperdymium motor. Designed to clean right up to the edge, it represents a tour-de-force of Dyson engineering.",
        "image": "https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Smart Home",
        "price": 1199.0,
        "avg_rating": 5.0,
        "external_url": "https://www.dyson.com/vacuum-cleaners/robotics/360-vis-nav/nickel-blue",
        "specifications": {
            "Motor": "Dyson Hyperdymium, 110,000 RPM",
            "Suction Power": "65 AW",
            "Vision": "360-degree panoramic camera",
            "Weight": "4.5 kg"
        },
        "reviews": [
            {
                "user_name": "Lisa W.",
                "rating": 5,
                "date": "May 16, 2026",
                "comment": "Outstanding suction power for a robot. Easily navigates and cleans corners effectively."
            }
        ]
    },
    {
        "prod_id": 35,
        "name": "TP-7 Field Recorder",
        "brand_name": "teenage engineering",
        "designer": "Teenage Engineering Studio",
        "detail": "The TP-7 is a pocket-sized field recorder built to record high-fidelity voice, music, and ambient sound. It features a motorized tape reel in the center that spins while recording and lets you scrub or pause with tactile satisfaction.",
        "image": "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Audio Recorders",
        "price": 1499.0,
        "avg_rating": 5.0,
        "external_url": "https://teenage.engineering/store/tp-7/",
        "specifications": {
            "Control": "Motorized scrub wheel",
            "Storage": "128GB internal storage",
            "Battery Life": "Up to 7 Hours",
            "Connectivity": "3 bidirectional minijacks, USB-C"
        },
        "reviews": [
            {
                "user_name": "Simon R.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "Tactile recording taken to a magical new level. The motorized wheel is pure genius."
            }
        ]
    },
    {
        "prod_id": 36,
        "name": "Analogue Pocket",
        "brand_name": "Analogue",
        "designer": "Analogue Design",
        "detail": "The Analogue Pocket is a multi-video-game-system portable hand-held. It functions as a tribute to portable gaming, running game cartridges natively via FPGA hardware with no software emulation, on an astonishing 615 ppi display.",
        "image": "https://images.unsplash.com/photo-1531525645387-7f14be1bdbbd?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Handhelds",
        "price": 219.0,
        "avg_rating": 5.0,
        "external_url": "https://www.analogue.co/pocket",
        "specifications": {
            "Display": "3.5\\",
            "Processors": "Altera Cyclone V FPGA, Cyclone IV FPGA",
            "Battery": "4300mAh Li-ion battery",
            "Compatibility": "Game Boy, GB Color, GBA cartridges"
        },
        "reviews": [
            {
                "user_name": "Alex G.",
                "rating": 5,
                "date": "May 12, 2026",
                "comment": "The screen is insane. Playing original cartridges on this is a nostalgic dream come true."
            }
        ]
    },
    {
        "prod_id": 37,
        "name": "reMarkable 2 Paper Tablet",
        "brand_name": "reMarkable",
        "designer": "Astro Studios",
        "detail": "At just 4.7 mm, the reMarkable 2 is the world's thinnest tablet. It is designed to replace your notebooks and printed documents with a paper-like writing experience, completely free from digital distractions.",
        "image": "https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Tablets",
        "price": 399.0,
        "avg_rating": 5.0,
        "external_url": "https://remarkable.com/store/remarkable2",
        "specifications": {
            "Display": "10.3\\",
            "Stylus Latency": "21ms ultra-low latency",
            "Thickness": "4.7 mm",
            "Battery Life": "Up to 2 weeks"
        },
        "reviews": [
            {
                "user_name": "Sarah T.",
                "rating": 5,
                "date": "May 10, 2026",
                "comment": "Friction of the stylus feels exactly like pencil on paper. Extremely elegant distraction-free notebook."
            }
        ]
    },
    {
        "prod_id": 38,
        "name": "Balmuda The Toaster",
        "brand_name": "Balmuda",
        "designer": "Gen Terao",
        "detail": "Utilizing precise steam technology and five specialized heat control modes, Balmuda The Toaster brings out the absolute best in any bread\u2014crisp on the outside and wonderfully moist and fluffy on the inside.",
        "image": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Smart Kitchen",
        "price": 299.0,
        "avg_rating": 5.0,
        "external_url": "https://us.balmuda.com/products/the-toaster",
        "specifications": {
            "Technology": "Steam and Microchip Temperature Control",
            "Modes": "Toast, Cheese Toast, French Bread, Croissant, Oven",
            "Water Inlet": "5cc miniature mug included"
        },
        "reviews": [
            {
                "user_name": "Hana Y.",
                "rating": 5,
                "date": "Apr 28, 2026",
                "comment": "Makes ordinary bakery bread taste like it came straight out of a professional Parisian oven."
            }
        ]
    },
    {
        "prod_id": 39,
        "name": "Theragun PRO Gen 5",
        "brand_name": "Therabody",
        "designer": "Dr. Jason Wersland",
        "detail": "The ultimate percussive therapy device, the Theragun PRO Gen 5 features a custom brushless motor with QuietForce Technology. It offers deep muscle recovery, pain relief, and smart guided routines via a vivid OLED screen.",
        "image": "https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Wellness",
        "price": 599.0,
        "avg_rating": 5.0,
        "external_url": "https://www.therabody.com/us/en-us/theragun-pro/",
        "specifications": {
            "Amplitude": "16mm depth for deep muscle therapy",
            "Speeds": "5 built-in speeds (1750-2400 PPM)",
            "Battery": "150-minute battery life via USB-C",
            "Attachments": "6 premium foam attachments"
        },
        "reviews": [
            {
                "user_name": "Marcus G.",
                "rating": 5,
                "date": "May 15, 2026",
                "comment": "Super quiet compared to the older versions. Absolute lifesaver for post-workout recovery."
            }
        ]
    },
    {
        "prod_id": 40,
        "name": "Leica M11 Rangefinder",
        "brand_name": "Leica",
        "designer": "Leica Design Studio",
        "detail": "The Leica M11 is a benchmark in digital rangefinder photography. Combining classic manual-focus photography with a 60MP triple-resolution sensor and an ultra-premium black paint finish on an aluminum top plate.",
        "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Technology",
        "type_name": "Cameras",
        "price": 8995.0,
        "avg_rating": 5.0,
        "external_url": "https://leica-camera.com/en-US/photography/cameras/m/m11-black",
        "specifications": {
            "Sensor": "60MP Full-Frame BSI CMOS",
            "Buffer": "3GB internal storage + SD slot",
            "Battery": "1800mAh high performance",
            "Weight": "530g (with battery)"
        },
        "reviews": [
            {
                "user_name": "Harvey S.",
                "rating": 5,
                "date": "May 25, 2026",
                "comment": "Pure, distilled photography. The mechanical rangefinder mechanism is beautifully precise."
            }
        ]
    },
    {
        "prod_id": 41,
        "name": "AW10 Watches",
        "brand_name": "Braun",
        "designer": "Dietrich Lubs & Dieter Rams",
        "detail": "First introduced in 1989, the Braun AW10 watch represents the epitome of functionalist watchmaking. Designed by Dietrich Lubs under Dieter Rams' philosophy of 'less, but better,' it features a clean layout, a high-contrast watch face with the signature yellow second hand, and a matte stainless steel case. A timeless statement of functional minimalism.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Analog Watches",
        "price": 220.0,
        "avg_rating": 5.0,
        "external_url": "https://www.braun-clocks.com/collections/watches",
        "specifications": {
            "Movement": "3-Hand Quartz",
            "Water Resistance": "3 ATM (30m)",
            "Case Material": "Stainless Steel",
            "Strap": "Premium Black Leather",
            "Case Diameter": "33mm"
        },
        "reviews": [
            {
                "user_name": "Dieter F.",
                "rating": 5,
                "date": "May 22, 2026",
                "comment": "A brilliant tribute to Rams' design ethos. It is extremely light, legible, and represents timeless elegance."
            },
            {
                "user_name": "Lucas G.",
                "rating": 4,
                "date": "May 02, 2026",
                "comment": "Extremely understated and elegant watch. Fits perfectly under a shirt cuff. A design classic."
            }
        ]
    },
    {
        "prod_id": 42,
        "name": "Max Bill Automatic",
        "brand_name": "Junghans",
        "designer": "Max Bill",
        "detail": "Designed in 1961 by Bauhaus student Max Bill, this timepiece represents the ultimate integration of Swiss watch precision and Bauhaus minimalist design. It features clean typography, a domed crystal, and a beautiful leather band.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Bauhaus Watches",
        "price": 1250.0,
        "avg_rating": 5.0,
        "external_url": "https://www.junghans.de/en/collection/watches/junghans-max-bill/max-bill-automatic/27350004",
        "specifications": {
            "Movement": "Self-winding movement J800.1",
            "Case": "Stainless Steel, 38mm",
            "Glass": "Domed sapphire crystal",
            "Strap": "Premium Calfskin leather"
        },
        "reviews": [
            {
                "user_name": "Felix B.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "The domed sapphire crystal catches the light beautifully. Vintage, elegant, and timeless."
            }
        ]
    },
    {
        "prod_id": 43,
        "name": "Speedmaster Professional",
        "brand_name": "Omega",
        "designer": "Pierre Moinat",
        "detail": "Known as the 'Moonwatch,' the Speedmaster Professional was qualified by NASA in 1965 for all manned space missions and worn during the historic lunar landing of Apollo 11. It features an asymmetric case and the famous dot over 90 bezel.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Chronographs",
        "price": 7600.0,
        "avg_rating": 5.0,
        "external_url": "https://www.omegawatches.com/en-us/watch-omega-speedmaster-moonwatch-professional-co-axial-master-chronometer-chronograph-42-mm-31030425001002",
        "specifications": {
            "Movement": "Omega Co-Axial Calibre 3861",
            "Case": "Stainless Steel, 42mm",
            "Bezel": "Anodized aluminum with tachymeter scale",
            "Power Reserve": "50 Hours"
        },
        "reviews": [
            {
                "user_name": "Neil A.",
                "rating": 5,
                "date": "May 10, 2026",
                "comment": "Incredible mechanical history on the wrist. Absolute design icon."
            }
        ]
    },
    {
        "prod_id": 44,
        "name": "Submariner Date",
        "brand_name": "Rolex",
        "designer": "Rolex Design Team",
        "detail": "The benchmark for divers' watches since 1953, the Submariner features a unidirectional rotatable bezel with a Cerachrom ceramic insert and a solid Oyster link bracelet. It is a masterpiece of rugged elegance.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Dive Watches",
        "price": 10250.0,
        "avg_rating": 5.0,
        "external_url": "https://www.rolex.com/en-us/watches/submariner",
        "specifications": {
            "Movement": "Rolex Calibre 3235, Automatic",
            "Case": "Oystersteel, 41mm",
            "Bezel": "Ceramic Cerachrom unidirectional",
            "Water Resistance": "300 meters / 1000 feet"
        },
        "reviews": [
            {
                "user_name": "Richard H.",
                "rating": 5,
                "date": "May 20, 2026",
                "comment": "Built like a tank but finished like a jewel. The perfect daily luxury watch."
            }
        ]
    },
    {
        "prod_id": 45,
        "name": "Royal Oak \\",
        "brand_name": "Audemars Piguet",
        "designer": "G\u00e9rald Genta",
        "detail": "Designed in a single day by the legendary G\u00e9rald Genta in 1972, the Royal Oak shocked the watchmaking world with its octagonal bezel, visible hexagonal screws, and integrated stainless steel bracelet.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Sport Watches",
        "price": 33200.0,
        "avg_rating": 5.0,
        "external_url": "https://www.audemarspiguet.com/com/en/collections/royal-oak.html",
        "specifications": {
            "Movement": "Self-winding Calibre 7121",
            "Case": "Stainless Steel, 39mm",
            "Dial": "Bleu Nuit Nuage 50 Petite Tapisserie",
            "Thickness": "8.1 mm"
        },
        "reviews": [
            {
                "user_name": "Charles G.",
                "rating": 5,
                "date": "May 23, 2026",
                "comment": "The way the light reflects off the brushed and polished bracelet links is absolutely magical."
            }
        ]
    },
    {
        "prod_id": 46,
        "name": "Nautilus 5711",
        "brand_name": "Patek Philippe",
        "designer": "G\u00e9rald Genta",
        "detail": "Inspired by the shape of a ship's porthole, Genta's 1976 Nautilus represents Patek Philippe's elegant vision of a luxury sports watch. With a horizontally embossed dial and an incredibly slim integrated profile.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Sport Watches",
        "price": 34800.0,
        "avg_rating": 5.0,
        "external_url": "https://www.patek.com/en/collection/nautilus",
        "specifications": {
            "Movement": "Calibre 26-330 S C, Automatic",
            "Case": "Stainless Steel, 40mm",
            "Dial": "Black-blue embossed gradient",
            "Thickness": "8.3 mm"
        },
        "reviews": [
            {
                "user_name": "Henry D.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "Incredibly thin and conforms to the wrist perfectly. The blue gradient dial is mesmerizing."
            }
        ]
    },
    {
        "prod_id": 47,
        "name": "Tank Louis Cartier",
        "brand_name": "Cartier",
        "designer": "Louis Cartier",
        "detail": "Designed in 1917, the Tank watch was inspired by the horizontal treads of military tanks on the Western Front. Worn by Andy Warhol, Jacqueline Kennedy, and Yves Saint Laurent, it is the definition of rectangular watchmaking luxury.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Dress Watches",
        "price": 12800.0,
        "avg_rating": 5.0,
        "external_url": "https://www.cartier.com/en-us/watches/collections/tank/tank-louis-cartier-watch-CRW1520033.html",
        "specifications": {
            "Movement": "Calibre 191 MC, Manual-wound",
            "Case": "18K Yellow Gold, 25.5mm x 33.7mm",
            "Crown": "Cabochon Sapphire",
            "Strap": "Alligator Leather"
        },
        "reviews": [
            {
                "user_name": "Pierre A.",
                "rating": 5,
                "date": "May 12, 2026",
                "comment": "Elegant, timeless, and completely genderless. It's not a watch, it's a piece of art."
            }
        ]
    },
    {
        "prod_id": 48,
        "name": "Lemnos Mono Clock",
        "brand_name": "Lemnos",
        "designer": "Riki Watanabe",
        "detail": "The Mono Clock is a wall clock designed by Japanese design pioneer Riki Watanabe in 2003. Inspired by functional legibility, it features a beautiful, sand-cast aluminum frame and clean modernist typography.",
        "image": "https://images.unsplash.com/photo-1563861826100-9cb868fdad1c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Wall Clocks",
        "price": 180.0,
        "avg_rating": 5.0,
        "external_url": "https://lemnos-store.com/en/collections/riki-watanabe/products/mono-clock",
        "specifications": {
            "Frame": "Sand-cast Aluminum",
            "Movement": "Sweep Second Quartz",
            "Dimensions": "10\\",
            "Origin": "Toyama, Japan"
        },
        "reviews": [
            {
                "user_name": "Kenzo O.",
                "rating": 5,
                "date": "Apr 28, 2026",
                "comment": "The sand-cast finish gives it a lovely, heavy texture. Beautifully silent movement."
            }
        ]
    },
    {
        "prod_id": 49,
        "name": "Q Timex Reissue",
        "brand_name": "Timex",
        "designer": "Timex Design Team",
        "detail": "First released in 1979, the Q Timex Reissue recreates the quartz watch revolution with modern vintage flair. It features a woven stainless steel bracelet, a functional battery hatch, and a striking pepsi bezel.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Quartz Watches",
        "price": 179.0,
        "avg_rating": 5.0,
        "external_url": "https://www.timex.com/q-timex-reissue-38mm-stainless-steel-3-hand-quartz-watch/Q-Timex-Reissue-38mm-Stainless-Steel-3-Hand-Quartz-Watch.html",
        "specifications": {
            "Movement": "Quartz analog",
            "Bezel": "Bi-directional Pepsi bezel",
            "Bracelet": "Woven Stainless Steel",
            "Diameter": "38mm"
        },
        "reviews": [
            {
                "user_name": "Jack S.",
                "rating": 4,
                "date": "May 08, 2026",
                "comment": "Fun, affordable, and incredibly retro. The woven steel band feels light and breezy."
            }
        ]
    },
    {
        "prod_id": 50,
        "name": "Nomos Tangente 38",
        "brand_name": "Nomos Glash\u00fctte",
        "designer": "Susanne G\u00fcnther",
        "detail": "Handcrafted in Glash\u00fctte, Germany, the Nomos Tangente features an ultra-slim case and Bauhaus-inspired typography. The sapphire crystal caseback reveals the beautifully finished manual-winding Alpha movement.",
        "image": "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Timepieces",
        "type_name": "Bauhaus Watches",
        "price": 2030.0,
        "avg_rating": 5.0,
        "external_url": "https://nomos-glashuette.com/en/tangente/tangente-38-164",
        "specifications": {
            "Movement": "NOMOS Alpha, Manual-wound",
            "Case": "Stainless Steel, 37.5mm",
            "Strap": "Horween Genuine Shell Cordovan",
            "Thickness": "6.7 mm"
        },
        "reviews": [
            {
                "user_name": "Frank M.",
                "rating": 5,
                "date": "May 25, 2026",
                "comment": "Extremely understated German precision. The shell cordovan strap is incredibly durable."
            }
        ]
    },
    {
        "prod_id": 51,
        "name": "Wooden Dolls No. 1",
        "brand_name": "Vitra",
        "designer": "Alexander Girard",
        "detail": "Alexander Girard designed the Wooden Dolls in 1953 for his own home in Santa Fe. These whimsical figures, inspired by his love for folk art and vibrant colors, are part playful toy and part decorative sculpture. Handcrafted and hand-painted in solid fir wood, each doll is a unique collector's piece that injects personality and mid-century character.",
        "image": "https://images.unsplash.com/photo-1558882224-cca166733360?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Home Accessories",
        "price": 155.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/wooden-dolls",
        "specifications": {
            "Material": "Solid Fir Wood, Hand-Painted",
            "Packaging": "High-Quality wooden gift box",
            "Origin": "Designed in 1953",
            "Dimensions": "2\\"
        },
        "reviews": [
            {
                "user_name": "Isabella P.",
                "rating": 5,
                "date": "May 08, 2026",
                "comment": "Each doll is hand-painted, meaning no two are identical. It brings so much warmth and artistic playfulness to our living room bookshelf."
            },
            {
                "user_name": "Alistair C.",
                "rating": 5,
                "date": "Apr 11, 2026",
                "comment": "Beautifully packaged, well-crafted, and a stellar collector's item for mid-century modern design enthusiasts."
            }
        ]
    },
    {
        "prod_id": 52,
        "name": "Savoy Vase",
        "brand_name": "Iittala",
        "designer": "Alvar Aalto",
        "detail": "Designed in 1936 by Finnish architect Alvar Aalto for the Paris World's Fair, the Savoy Vase features fluid, organic curves inspired by the Finnish lakes. Each vase is mouth-blown and handcrafted at the Iittala glass factory in Finland.",
        "image": "https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Vases",
        "price": 260.0,
        "avg_rating": 5.0,
        "external_url": "https://www.iittala.com/en-us/collections/aalto-vase-160mm-moss-green-1060410",
        "specifications": {
            "Material": "Lead-free Glass, Mouth-blown",
            "Dimensions": "6.3\\",
            "Origin": "Iittala, Finland",
            "Designer Year": "1936"
        },
        "reviews": [
            {
                "user_name": "Sofia A.",
                "rating": 5,
                "date": "May 10, 2026",
                "comment": "Mouth-blown glass has such an organic feel. The undulating curves make flowers sit beautifully."
            }
        ]
    },
    {
        "prod_id": 53,
        "name": "Juicy Salif Citrus Squeezer",
        "brand_name": "Alessi",
        "designer": "Philippe Starck",
        "detail": "Described by Starck as 'not designed to squeeze lemons, but to start conversations,' the Juicy Salif is a revolutionary, tripod citrus squeezer made of cast aluminum. It is a controversial and iconic staple of 20th-century design.",
        "image": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Kitchen Accessories",
        "price": 110.0,
        "avg_rating": 5.0,
        "external_url": "https://alessi.com/products/juicy-salif-citrus-squeezer",
        "specifications": {
            "Material": "Cast Aluminum",
            "Legs": "PA (Polyamide) feet protect countertops",
            "Dimensions": "5.5\\",
            "Origin": "Italy"
        },
        "reviews": [
            {
                "user_name": "Pierre S.",
                "rating": 4,
                "date": "May 15, 2026",
                "comment": "Terrible at catching pulp, but absolute perfection as a kinetic table sculpture."
            }
        ]
    },
    {
        "prod_id": 54,
        "name": "Lemnos Birdhouse Clock",
        "brand_name": "Lemnos",
        "designer": "Yuichi Nara",
        "detail": "Designed by Yuichi Nara, the Birdhouse Clock is a modern interpretation of the classic cuckoo clock. Housed in a solid wood frame, the mechanical cuckoo sings a soft stream sound accompanied by a delicate bird call on the hour.",
        "image": "https://images.unsplash.com/photo-1563861826100-9cb868fdad1c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Cuckoo Clocks",
        "price": 320.0,
        "avg_rating": 5.0,
        "external_url": "https://lemnos-store.com/en/collections/birdhouse-clock/products/birdhouse-clock",
        "specifications": {
            "Material": "Japanese Lime wood plinth",
            "Sensor": "Integrated light sensor silences cuckoo at night",
            "Dimensions": "7.1\\"
        },
        "reviews": [
            {
                "user_name": "Kenji N.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "The cuckoo sound is a recording of a real bird and stream\u2014incredibly natural and peaceful."
            }
        ]
    },
    {
        "prod_id": 55,
        "name": "L'Oiseau Ceramic",
        "brand_name": "Vitra",
        "designer": "Ronan & Erwan Bouroullec",
        "detail": "Handcrafted in glazed ceramic, L'Oiseau is a modern decorative bird sculpture designed by the Bouroullec brothers. Its clean, organic lines convey a sense of calm and sculptural weight without any decorative excess.",
        "image": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Sculptures",
        "price": 175.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/loiseau",
        "specifications": {
            "Material": "Glazed Ceramic, Hand-finished",
            "Colors": "Charcoal, Cream, Moss Green",
            "Dimensions": "9.6\\"
        },
        "reviews": [
            {
                "user_name": "Marie C.",
                "rating": 5,
                "date": "May 11, 2026",
                "comment": "Perfect weight and texture. The simplicity of the shape is incredibly calming."
            }
        ]
    },
    {
        "prod_id": 56,
        "name": "Block Lamp",
        "brand_name": "Design House Stockholm",
        "designer": "Harri Koskinen",
        "detail": "Introduced in 1996, Harri Koskinen's Block Lamp is a modern classic. Composed of a bulb suspended between two hand-cast clear glass blocks, it resembles an incandescent bulb frozen inside a block of clear ice.",
        "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Sculptures",
        "price": 265.0,
        "avg_rating": 5.0,
        "external_url": "https://designhousestockholm.com/products/block-lamp",
        "specifications": {
            "Material": "Hand-cast Glass, textile cord",
            "Bulb": "E12 LED bulb included",
            "Dimensions": "6.3\\",
            "Origin": "Sweden"
        },
        "reviews": [
            {
                "user_name": "Elsa S.",
                "rating": 5,
                "date": "May 08, 2026",
                "comment": "Stunning heavy glass blocks. The ambient light reflecting through the textured ice is gorgeous."
            }
        ]
    },
    {
        "prod_id": 57,
        "name": "Kastehelmi Bowl",
        "brand_name": "Iittala",
        "designer": "Oiva Toikka",
        "detail": "Designed in 1964 by legendary Finnish glass designer Oiva Toikka, Kastehelmi (Finnish for 'dewdrop') features concentric rings of glass droplets that resemble glinting dewdrops under the morning Nordic sun.",
        "image": "https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Glassware",
        "price": 40.0,
        "avg_rating": 5.0,
        "external_url": "https://www.iittala.com/en-us/tableware/bowls/kastehelmi-bowl-14oz-clear-1007823",
        "specifications": {
            "Material": "Pressed lead-free glass",
            "Dishwasher": "Dishwasher safe",
            "Dimensions": "4.3\\",
            "Origin": "Finland"
        },
        "reviews": [
            {
                "user_name": "Heli K.",
                "rating": 5,
                "date": "Apr 30, 2026",
                "comment": "Beautifully tactile pressed glass. The drops refract light beautifully."
            }
        ]
    },
    {
        "prod_id": 58,
        "name": "Stelton EM77 Vacuum Jug",
        "brand_name": "Stelton",
        "designer": "Erik Magnussen",
        "detail": "Designed in 1977, the EM77 vacuum jug features Magnussen's iconic rocker stopper. When the jug is lifted, the stopper opens automatically, and closes when placed back down. An absolute milestone in functionalist design.",
        "image": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Tableware",
        "price": 95.0,
        "avg_rating": 5.0,
        "external_url": "https://www.stelton.com/en/em77-vacuum-jug-1-l",
        "specifications": {
            "Material": "ABS Plastic, Glass inner insert",
            "Capacity": "1.0 Liter / 33.8 oz",
            "Stopper": "Unique rocker stopper + screw cap",
            "Origin": "Denmark"
        },
        "reviews": [
            {
                "user_name": "Soren P.",
                "rating": 5,
                "date": "May 14, 2026",
                "comment": "The rocker stopper is brilliant and works perfectly. Kept my coffee boiling hot for hours."
            }
        ]
    },
    {
        "prod_id": 59,
        "name": "Rotary Tray",
        "brand_name": "Vitra",
        "designer": "Jasper Morrison",
        "detail": "The Rotary Tray is a modern interpretation of the classic Lazy Susan. Featuring a rotating top tier, its clean geometry and matte finish make it an elegant organization tool for desks, kitchens, or coffee tables.",
        "image": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Storage",
        "price": 85.0,
        "avg_rating": 5.0,
        "external_url": "https://www.vitra.com/en-us/product/rotary-tray",
        "specifications": {
            "Material": "Textured ABS Plastic",
            "Mechanism": "Rotating upper tier",
            "Dimensions": "11.75\\",
            "Origin": "Germany"
        },
        "reviews": [
            {
                "user_name": "Olivia G.",
                "rating": 5,
                "date": "May 22, 2026",
                "comment": "Looks wonderful on my entryway console table to hold keys and sunglasses. Solid build quality."
            }
        ]
    },
    {
        "prod_id": 60,
        "name": "Kaleido Tray Small",
        "brand_name": "Hay",
        "designer": "Clara von Zweigbergk",
        "detail": "Designed by Clara von Zweigbergk, the Kaleido collection is a series of modular, geometric steel trays that can be nested together to create beautiful, colorful configurations.",
        "image": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=800&auto=format&fit=crop",
        "cat_name": "Objects",
        "type_name": "Storage",
        "price": 35.0,
        "avg_rating": 5.0,
        "external_url": "https://hay.dk/hay/kaleido-x-small",
        "specifications": {
            "Material": "Powder-coated steel",
            "Design": "Modular nesting geometry",
            "Dimensions": "7.5\\"
        },
        "reviews": [
            {
                "user_name": "Leo F.",
                "rating": 5,
                "date": "May 18, 2026",
                "comment": "The geometric options are endless. I love matching different colors together."
            }
        ]
    }
]
"""#
}
