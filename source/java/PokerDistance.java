/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pokerdistance;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import mdsj.MDSJ;

/**
 *
 * @author james
 */
public class PokerDistance {

    /**
     * @param args the command line arguments
     * @throws java.io.FileNotFoundException
     */
    public static void main(String[] args) throws FileNotFoundException, IOException {
        double max  = 0;
        int    maxi = 0;
//        for (int i = 1; i <= 20; i++){
//            System.out.printf("Running %f\n", 2.0 * i);
//            double[] nums = runStuff(2.0 * i);
//            double ratio  = nums[1] / nums[0];
//            System.out.printf("Ratio: %f\n", ratio);
//            if (ratio > max){
//                max = ratio;
//                maxi  = i;
//            }
//        }
//        System.out.printf("\nMax %f at %f", max, maxi * 2.0);
        runNewStuff(16.0);
    }
    
    public static double[] runStuff(double multiplier) throws FileNotFoundException, IOException{
        // Create local variables
        BufferedReader inFile;
        File directory = new File("input");
        ArrayList<Player> players = new ArrayList();
        // Get list of files in directory
        File[] files = directory.listFiles();
        // While there are files
            for (File file : files){
                String name = file.getName().split(".hands")[0];
                // Open each file and create two players, one for each partition
                inFile = new BufferedReader(new FileReader(file));
                String line;
                double num;
                String firstLine = inFile.readLine();
                Double winnings = Double.parseDouble(firstLine.split(",? ")[2]);
                Double hands    = Double.parseDouble(firstLine.split(",? ")[5]);
                Double winrate  = (winnings / hands) * 100;
                double[][] handValues = new double[13][13];
                for (int k = 1; k < 4; k++){
                    inFile.readLine();
                }
                for (int i = 0; i < 13; i++) {
                    line = inFile.readLine();
                    String[] strings = line.split(" ");
                    for(int j = 0; j < 13; j++){
                        num = Double.parseDouble(strings[j]);
                        handValues[i][j] = num;
                    }
                }
                players.add(new Player(name + "A",winrate,handValues,multiplier));
                double[][] handValues2 = new double[13][13];
//                for (int i = 0; i < 173; i++){
//                    inFile.readLine();
//                }
//                for (int i = 0; i < 13; i++) {
//                    line = inFile.readLine();
//                    String[] strings = line.split(" ");
//                    for(int j = 0; j < 13; j++){
//                        num = Double.parseDouble(strings[j]);
//                        handValues2[i][j] = num;
////                        handValues[i][j] += num;
////                        handValues[i][j] = handValues[i][j] / 2;
//                    }
//                }   
//                players.add(new Player(name + "B",winrate,handValues2,multiplier));
                //players.add(new Player(name,winrate,handValues));
            }
        // Go through each player on list
        double[][] matrix = new double[players.size()][players.size()];
        for (int i = 0; i < players.size(); i++){
            // Calculate their pairwise distance to each subsequent player
            // Record those distances
            for (int j = 0; j < players.size(); j++){
                Player playerOne = players.get(i);
                Player playerTwo = players.get(j);
                double distance = playerOne.distanceOnePlus(playerTwo);
                matrix[i][j] = distance;
                //System.out.printf("%3.2f ", distance);
            }
            //System.out.println();
        }
        Stats stats = new Stats(matrix);
        double[][] output = MDSJ.classicalScaling(matrix, 3);
        for (int i = 0; i < output[0].length; i++) {
            for (int j = 0; j < output.length; j++) {
                System.out.print(output[j][i] + " ");
            }
            players.get(i).rateAndName();
            System.out.println();
        }
//        System.out.println(stats.getAvgABDistance());
//        System.out.println(stats.getMedianABDistance());
//        System.out.println(stats.getAvgDistance());
//        System.out.println(stats.getMedianDistance());
//        for (int i = 0; i < players.size(); i++){
//            players.get(i).printNameAndWinRate();
//        }
        // Output results
        
        return new double[]{stats.getAvgABDistance(), stats.getAvgNABDistance()};
    }
    
     public static double[] runNewStuff(double multiplier) throws FileNotFoundException, IOException{
        // Create local variables
        BufferedReader inFile;
        File directory = new File("inputNew");
        ArrayList<AllPointPlayer> players = new ArrayList();
        // Get list of files in directory
        File[] files = directory.listFiles();
        // While there are files
            for (File file : files){
                String name = file.getName().split(".hands")[0];
                // Open each file and create two players, one for each partition
                inFile = new BufferedReader(new FileReader(file));
                String line;
                double num;
                ArrayList<Double[]> hands = new ArrayList();
                String inLine = inFile.readLine();
                String[] parts = inLine.split(" ");
                Double[] hand = new Double[3];
                while (parts.length == 3){
                    hand[0] = Double.parseDouble(parts[0]);
                    hand[1] = Double.parseDouble(parts[1]);
                    hand[2] = Double.parseDouble(parts[2]);
                    hands.add(hand);
                    hand = new Double[3];
                    inLine = inFile.readLine();
                    parts = inLine.split(" ");
                }
                inLine = inFile.readLine();
                String firstLine = inFile.readLine();
                Double winnings = Double.parseDouble(firstLine.split(",? ")[2]);
                Double handCount    = Double.parseDouble(firstLine.split(",? ")[5]);
                Double winrate  = (winnings / handCount) * 100;
                
                players.add(new AllPointPlayer(name,winrate, hands));
//                for (int i = 0; i < 173; i++){
//                    inFile.readLine();
//                }
//                for (int i = 0; i < 13; i++) {
//                    line = inFile.readLine();
//                    String[] strings = line.split(" ");
//                    for(int j = 0; j < 13; j++){
//                        num = Double.parseDouble(strings[j]);
//                        handValues2[i][j] = num;
////                        handValues[i][j] += num;
////                        handValues[i][j] = handValues[i][j] / 2;
//                    }
//                }   
//                players.add(new Player(name + "B",winrate,handValues2,multiplier));
                //players.add(new Player(name,winrate,handValues));
            }
        // Go through each player on list
        double[][] matrix = new double[players.size()][players.size()];
        for (int i = 0; i < players.size(); i++){
            // Calculate their pairwise distance to each subsequent player
            // Record those distances
            for (int j = 0; j < players.size(); j++){
                AllPointPlayer playerOne = players.get(i);
                AllPointPlayer playerTwo = players.get(j);
                double distance = playerOne.distanceOnePlus(playerTwo);
                matrix[i][j] = distance;
                System.out.printf("%3.2f ", distance);
            }
            System.out.println();
        }
        
        Stats stats = new Stats(matrix);
        
        System.out.println("Reflexive: " + stats.getReflexiveVariance());
        System.out.println("Non-Reflex: " + stats.getNonReflexiveVariance());
        
        double[][] output = MDSJ.classicalScaling(matrix);
        for (int i = 0; i < output[0].length; i++) {
            for (int j = 0; j < output.length; j++) {
                System.out.print(output[j][i] + " ");
            }
            players.get(i).rateAndName();
            System.out.println();
        }
//        System.out.println(stats.getAvgABDistance());
//        System.out.println(stats.getMedianABDistance());
//        System.out.println(stats.getAvgDistance());
//        System.out.println(stats.getMedianDistance());
//        for (int i = 0; i < players.size(); i++){
//            players.get(i).printNameAndWinRate();
//        }
        // Output results
        
        return new double[]{stats.getAvgABDistance(), stats.getAvgNABDistance()};
    }
}
