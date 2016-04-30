/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pokerdistance;

/**
 *
 * @author james
 */
public class Player {    
    private final double DISTANCE_MULTIPLIER;
    private String name;
    private double winrate;
    private double[][] handValues;
    
    public Player(String inName, double inRate, double[][]inValues) {
        name = inName;
        winrate = inRate;
        handValues = inValues;
        DISTANCE_MULTIPLIER = 1;
    }
    
    public Player(String inName, double inRate, double[][]inValues, double inMult) {
        name = inName;
        winrate = inRate;
        handValues = inValues;
        DISTANCE_MULTIPLIER = inMult;
    }
    
    private double minDistance(double x, double y, double z){
        double min = 100000000.00;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues.length; j++){
                min = Math.min(min, 
                        Math.sqrt(Math.pow((x - i) * DISTANCE_MULTIPLIER, 2) + 
                                  Math.pow((y - j) * DISTANCE_MULTIPLIER, 2) +
                                  Math.pow(z - handValues[i][j], 2)));
            }
        }
        return min;
    }
    
    public double distanceOne(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance += Math.abs(handValues[i][j] - other.handValues[i][j]);
            }
        }
        return distance;
    }
    
    public double distanceOnePlus(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance += other.minDistance(i, j, handValues[i][j]);
            }
        }
        return distance;
    }
    
    public double distanceTwo(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance += Math.pow(handValues[i][j] - other.handValues[i][j], 2);
            }
        }
        return Math.sqrt(distance);
    }
    
    public double distanceTwoPlus(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance += Math.pow(other.minDistance(i, j, handValues[i][j]), 2);
            }
        }
        return Math.sqrt(distance);
    }
    
    public double distanceInf(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance = Math.max(Math.abs(handValues[i][j] - 
                                            other.handValues[i][j]), distance);
            }
        }
        return distance;
    }
    
    public double distanceInfPlus(Player other){
        double distance = 0;
        for (int i = 0; i < handValues.length; i++){
            for (int j = 0; j < handValues[i].length; j++){
                distance = Math.max(other.minDistance(i, j, handValues[i][j]), distance);
            }
        }
        return distance;
    }
    
    public void printInfo(){
        System.out.println(name);
        System.out.println(winrate);
        for (double[] line : handValues){
            for (double value : line){
                System.out.print(value + " ");
            }
            System.out.println();
        }
    }
    
    public void printNameAndWinRate(){
        System.out.println(name + ": " + winrate);
    }
    
    public void rateAndName(){
        System.out.print(winrate + " " + name);
    }
}
