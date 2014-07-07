//
//  InsightEngine.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface InsightEngine : NSObject


+ (InsightEngine*) sharedInsight;


-(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor;
-(NSString*)generateWelcomeTextForGPSdetectedMajor:(NSNumber*)major;


@end
