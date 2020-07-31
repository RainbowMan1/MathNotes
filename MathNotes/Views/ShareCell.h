//
//  ShareCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) Friend *shareFriend;
@end

NS_ASSUME_NONNULL_END
