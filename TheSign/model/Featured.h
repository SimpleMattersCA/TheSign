//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define FEATURED (@"Featured")
#define FEATURED_TITLE (@"title")
#define FEATURED_DETAILS (@"details")
#define FEATURED_VIDEO (@"videoUrl")
#define FEATURED_IMAGE (@"image")
#define FEATURED_BUSINESS (@"parentBusiness")
#define FEATURED_MAJOR (@"major")
#define FEATURED_MINOR (@"minor")
#define FEATURED_ACTIVE (@"active")

@class Business, Favourites, TagSet,PFObject;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) Favourites *favourited;
@property (nonatomic, retain) TagSet *featuredTagSet;
@property (nonatomic, retain) Business *parentBusiness;


+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;

@end
