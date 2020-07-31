//
//  Friend.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#ifndef Friend_h
#define Friend_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend :NSObject

@property (nonatomic, strong) NSString *FBID;
@property (nonatomic, strong) NSString *friendName;
@property (nonatomic, strong) NSString *friendProfilePicImageURL;


@end

#endif /* Friend_h */
