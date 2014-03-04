//
//  PopulateView.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/23/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "PopulateView.h"



@interface PopulateView()
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) NSArray *descriptions;
@end


@implementation PopulateView



-(NSArray*) titles
{
    if(!_titles) _titles=[[NSArray alloc] initWithObjects:@"SHop1",@"Shop2",@"Shop3", nil];
    return _titles;
}


-(NSArray*) descriptions
{
    if(!_descriptions) _descriptions=[[NSArray alloc] initWithObjects:@"Text 1 mkasldmsalkdmlksadm",@"TExt 2alskdmlaskmdklasmd",@"TExt3 asmdasldmlaskmd", nil];
    return _descriptions;
}

-(InfoModel*)getTextByID:(NSInteger) ID
{

    InfoModel *obj=[[InfoModel alloc] init];
    
    obj.title=self.titles[ID];
    obj.description=self.descriptions[ID];
    
    return obj;
}





@end
