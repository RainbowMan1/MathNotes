//
//  ShareNoteViewController.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShareDelegate

- (void) didShareToFBID:(NSString *)FBID;
- (void) didShareToUsername;
 
@end

@interface ShareViewController : UIViewController
@property (weak, nonatomic) id<ShareDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
