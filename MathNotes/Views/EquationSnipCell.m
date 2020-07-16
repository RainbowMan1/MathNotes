//
//  EquationSnipCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipCell.h"

@implementation EquationSnipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setEquationSnip:(EquationSnip *)equationSnip {
    (_equationSnip) = equationSnip;
    [self updateCell];
}

- (void)updateCell {
    self.equationSnipName.text =  self.equationSnip.equationSnipName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    self.lastUpdatedTimeLabel.text = [formatter  stringFromDate:self.equationSnip.updatedAt];
}

@end
