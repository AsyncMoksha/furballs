//
//  WikiLabel.h
//  PAWS
//
//  Created by Zinan Xing on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WikiLabel : CCNode {
    CCSprite *_labelSprite;
    CCLabelBMFont *_info;
}
-(id) initWithLabelFileName: (NSString*) filename andInfo: (NSString*) inInfo;
@property (nonatomic, retain) CCSprite *labelSprite;
@property (nonatomic, retain) CCLabelBMFont *info;
@end
