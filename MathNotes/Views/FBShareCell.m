//
//  ShareCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/30/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "FBShareCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FBShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setShareFriend:(Friend *)shareFriend {
    _shareFriend = shareFriend;
    [self updateCell];
}

- (void)updateCell {
    self.nameLabel.text =  self.shareFriend.friendName;
    [self.profilePicView setImageWithURL:[NSURL URLWithString:self.shareFriend.friendProfilePicImageURL]];
}


@end
