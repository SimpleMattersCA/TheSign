//
//  Link.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define LINK (@"Link")
#define LINK_URL (@"url")
#define LINK_BUSINESS (@"uid")

@class Business;

@interface Link : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Business *parentBusiness;

@end
