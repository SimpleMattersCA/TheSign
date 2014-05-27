//
//  TagClassConnection.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define TAGCLASSCONNECTION (@"TagClassConnection")
#define TAGCLASSCONNECTION_WEIGHT (@"weight")
#define TAGCLASSCONNECTION_CONTROLCLASS (@"controllClass")
#define TAGCLASSCONNECTION_RELATEDCLASS (@"relatedClass")

@class TagClass;

@interface TagClassConnection : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) TagClass *controllClass;
@property (nonatomic, retain) TagClass *relatedClass;

@end
