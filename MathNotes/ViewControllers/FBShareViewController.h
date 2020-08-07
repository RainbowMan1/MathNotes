//
//  ShareNoteViewController.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBShareDelegate

- (void) didShareToFBID:(NSString *)FBID;
- (void) didShareToUsername;
 
@end

@interface FBShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id<FBShareDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
