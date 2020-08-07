//
//  SharedUserCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 8/6/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "SharedUserCell.h"

@implementation SharedUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSharedUser:(PFUser *)sharedUser{
    _sharedUser = sharedUser;
    [self updateCell];
}

- (void)updateCell{
    self.usernameLabel.text = self.sharedUser.username;
}
- (IBAction)stopSharing:(id)sender {
    [self.delegate didDeleteUser:self.sharedUser withSender:self];
}

@end
