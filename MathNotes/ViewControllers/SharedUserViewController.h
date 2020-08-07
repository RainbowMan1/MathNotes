//
//  SharedUserViewController.h
//  MathNotes
//
//  Created by Nikesh Subedi on 8/6/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol SharedUserViewControllerDelegate

- (void) updateTable;

@end

@interface SharedUserViewController : UIViewController

@property (strong, nonatomic) PFObject *sharedObject;
@property (weak, nonatomic) id<SharedUserViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
