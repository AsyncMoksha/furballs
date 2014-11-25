//
//  CCLevelButtonImage.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/13/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "CCMenuItem.h"

@interface CCLevelButtonImage : CCMenuItemImage
{
    NSInteger levelID;
    
}



@property (nonatomic, assign) NSInteger levelID;

@end
