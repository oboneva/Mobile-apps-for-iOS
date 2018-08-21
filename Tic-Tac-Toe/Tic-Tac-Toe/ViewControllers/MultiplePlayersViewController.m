//
//  MultiplePlayersViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultiplePlayersViewController.h"
#import "GameViewController.h"

#import "PlayerModel.h"
#import "HumanModel.h"

#import "GameEngine.h"

#import "Utilities.h"
#import "Constants.h"

#define PLAYER1_DEFAULT_NAME @"Player1"
#define PLAYER2_DEFAULT_NAME @"Player2"

@interface MultiplePlayersViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstPlayerName;
@property (weak, nonatomic) IBOutlet UITextField *secondPlayerName;
@property (assign) EnumGame gameType;
@end

@implementation MultiplePlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.firstPlayerName.delegate = self;
    self.secondPlayerName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onPlayTap:(id)sender {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    
    NSString *playerName = self.firstPlayerName.text;
    if ([playerName isEqualToString:EMPTY_TEXT]) {
        playerName = PLAYER1_DEFAULT_NAME;
    }
    HumanModel *player1 = [[HumanModel alloc] initWithName:playerName];
    
    playerName = self.secondPlayerName.text;
    if ([playerName isEqualToString:EMPTY_TEXT]) {
        playerName = PLAYER2_DEFAULT_NAME;
    }
    HumanModel *player2 = [[HumanModel alloc] initWithName:playerName];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    [gameController setEngine:engine];
    
    gameController.gameMode = EnumGameModeOneDevice;
    gameController.gameType = self.gameType;
    [self.navigationController pushViewController:gameController animated:YES];
}

@end
