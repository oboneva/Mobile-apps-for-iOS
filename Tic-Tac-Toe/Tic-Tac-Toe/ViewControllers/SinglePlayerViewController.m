//
//  SinglePlayerViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "GameViewController.h"

#import "HumanModel.h"

#import "GameEngine.h"

#import "Utilities.h"


@interface SinglePlayerViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *playerName;
@property (weak, nonatomic) IBOutlet UIPickerView *difficultyPicker;
@property (strong, nonatomic) NSArray *difficultyLevels;
@property (assign) EnumDifficulty difficulty;
@property (assign) EnumGame gameType;

@end

@implementation SinglePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.difficultyLevels = @[@"Easy", @"Medium", @"Hard"];
    
    self.difficultyPicker.dataSource = self;
    self.difficultyPicker.delegate = self;
    
    self.gameType = EnumGameTicTacToe;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.playerName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.difficultyLevels.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.difficultyLevels[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.difficulty = EnumDifficultyMedium;
    if ([self.difficultyLevels[row] isEqualToString:@"Easy"]) {
        self.difficulty = EnumDifficultyEasy;
    }
    else if ([self.difficultyLevels[row] isEqualToString:@"Hard"]) {
        self.difficulty = EnumDifficultyHard;
    }
}

- (IBAction)onPlayTap:(id)sender {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerName.text];
    BotModel *player2 = [Utilities botWithDifficulty:self.difficulty];

    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    [engine setUpPlayers];

    [gameController setEngine:engine];
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onGameSwitchTap:(id)sender {
    if (self.gameType == EnumGameTicTacToe) {
        self.gameType = EnumGameTunakTunakTun;
    }
    else {
        self.gameType = EnumGameTicTacToe;
    }
}

@end
