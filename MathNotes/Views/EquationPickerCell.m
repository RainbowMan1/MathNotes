//
//  EquationPickerCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/31/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationPickerCell.h"
#import "MTFontManager.h"

@interface EquationPickerCell()<UIAdaptivePresentationControllerDelegate>

@end

@implementation EquationPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openMenu:(id)sender {
    [self.delegate tapOnMenu:(UIButton *) sender forEquationSnip:self.equationSnip];
}

- (void)setEquationSnip:(EquationSnip *)equationSnip {
    (_equationSnip) = equationSnip;
    [self updateCell];
}

- (void)updateCell {
    self.nameLabel.text =  self.equationSnip.equationSnipName;
    NSString *latex = self.equationSnip.laTeXcode;
       self.equationPreview.latex= [self preparedPreview:latex];
       self.equationPreview.textAlignment = kMTTextAlignmentCenter;
       self.equationPreview.font = [[MTFontManager fontManager] termesFontWithSize:18];
       if (self.equationPreview.error!=nil){
           self.equationPreview.latex = @"\\text{ Preview Unavailable.}";
       }
}
- (NSString *)preparedPreview:(NSString *)latex {
    latex =  [latex stringByReplacingOccurrencesOfString:@"\\text {" withString:@"\\text{"];
    latex = [latex stringByReplacingOccurrencesOfString:@"\\operatorname{" withString:@"\\text{"];
    return latex;
}

@end
