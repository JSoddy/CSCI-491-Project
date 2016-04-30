/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pokerdistance;

import java.util.ArrayList;

/**
 *
 * @author james
 */
public class AllPointPlayer {    
    private final double DISTANCE_MULTIPLIER;
    private String name;
    private double winrate;
    ArrayList<Double[]> handValues;
    
    public AllPointPlayer(String inName, double inRate) {
        name = inName;
        winrate = inRate;
        handValues = new ArrayList();
        DISTANCE_MULTIPLIER = 16;
    }
    
    public AllPointPlayer(String inName, double inRate, ArrayList<Double[]> inHands) {
        name = inName;
        winrate = inRate;
        handValues = inHands;
        DISTANCE_MULTIPLIER = 16;
    }
    
    private double minDistance(double x, double y, double z){
        double min = 100000000.00;
        for (int i = 0; i < handValues.size(); i++){
            min = Math.min(min, 
                        Math.sqrt(Math.pow((x - handValues.get(i)[0]) * DISTANCE_MULTIPLIER, 2) + 
                                  Math.pow((y - handValues.get(i)[1]) * DISTANCE_MULTIPLIER, 2) +
                                  Math.pow(z - handValues.get(i)[2], 2)));
            }
        return min;
    }
    
    public double distanceOnePlus(AllPointPlayer other){
        double distance = 0;
        for (int i = 0; i < handValues.size(); i++){
            distance += other.minDistance(handValues.get(i)[0], handValues.get(i)[1], handValues.get(i)[2]);
        }
        return distance / handValues.size();
    }
    
    public double distanceTwoPlus(AllPointPlayer other){
        double distance = 0;
        for (int i = 0; i < handValues.size(); i++){
            distance += Math.pow(other.minDistance(handValues.get(i)[0], handValues.get(i)[1], handValues.get(i)[2]), 2);
        }
        return Math.sqrt(distance / handValues.size());
    }
    
    public double distanceInfPlus(AllPointPlayer other){
        double distance = 0;
        for (int i = 0; i < handValues.size(); i++){
            distance += Math.max(other.minDistance(handValues.get(i)[0], handValues.get(i)[1], handValues.get(i)[2]), distance);
        }
        return distance;
    }
    
    public void printNameAndWinRate(){
        System.out.println(name + ": " + winrate);
    }
    
    public void rateAndName(){
        System.out.print(winrate + " " + name);
    }
}
