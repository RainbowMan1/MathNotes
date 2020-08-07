//
//  SharedUserCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 8/6/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol SharedUserDelegate

- (void)didDeleteUser:(PFUser *)user withSender:(id) sender;

@end

@interface SharedUserCell : UITableViewCell

@property (strong, nonatomic) PFUser *sharedUser;
@property (weak, nonatomic) id<SharedUserDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end


NS_ASSUME_NONNULL_END
