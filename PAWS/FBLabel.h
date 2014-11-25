//
//  FBLabel.h
//  PAWS
//
//  Created by Zinan Xing on 11/26/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FBLabel : CCNode {
    CCSprite *_labelSprite;
    CCLabelBMFont *_info;
    //CCMenuItem *info;
}
-(id) initWithLabelFileName: (NSString*) filename andInfo: (NSString*) inInfo;
@property (nonatomic, retain) CCSprite *labelSprite;
@property (nonatomic, retain) CCLabelBMFont *info;
@end