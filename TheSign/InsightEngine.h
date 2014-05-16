//
//  InsightEngine.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeader.h"
#import "Model.h"

typedef NS_ENUM(NSInteger, SentenceType) {
    //it's hot/cold, would you like some.... Also we should track First snow
    Weather,
    //we're closing in 30 minutes so you still have a time to check out..
    Time,
    //At the beginning of the winter, summer, fall and spring
    Season,
    //if someone is visitting very often
    Frequency,
    
    //based on what was marked as favourite
    Favourites
};

@interface InsightEngine : NSObject

+(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor;



@end
