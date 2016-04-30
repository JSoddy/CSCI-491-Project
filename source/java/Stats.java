/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pokerdistance;

import java.util.Arrays;

/**
 *
 * @author james
 */
public class Stats {
    double[][] matrix;
    String[] names;
    double[] winrates;

    public Stats(double[][] inMatrix){
        matrix = inMatrix;
    }
    
    public double getAvgABDistance(){
        double avgDistance = 0;
        for (int i = 0; i < matrix.length - 1; i += 2){
            avgDistance += matrix[i][i+1];
            avgDistance += matrix[i+1][i];
        }
        return avgDistance / matrix.length;
    }
    
    public double getMedianABDistance(){
        double[] distances = new double[matrix.length];
        for (int i = 0; i < matrix.length - 1; i += 2){
            distances[i] = matrix[i][i+1];
            distances[i+1] = matrix[i+1][i];
        }
        Arrays.sort(distances);
        double median = (distances[distances.length/2] + 
                  distances[distances.length/2 + 1]) / 2;
        return median;
    }
    
    public double getAvgDistance(){
        double totDistance = 0;
        for (int i = 0; i < matrix.length; i++){
            for (int j = 0; j < matrix[i].length; j++){
                if (j != i){
                    totDistance += matrix[i][j];
                }
            }
        }
        return totDistance / (matrix.length * matrix.length - matrix.length);
    }
    
    private double getTotABDistance(){
        double totDistance = 0;
            for (int i = 0; i < matrix.length - 1; i += 2){
                totDistance += matrix[i][i+1];
                totDistance += matrix[i+1][i];
            }
        return totDistance;
    }
        
    public double getAvgNABDistance(){
        double totDistance = 0;
        for (int i = 0; i < matrix.length; i++){
            for (int j = 0; j < matrix[i].length; j++){
                if (j != i){
                    totDistance += matrix[i][j];
                }
            }
        }
        totDistance -= getTotABDistance();
        return totDistance / (matrix.length * (matrix.length - 2));
    }
    
    
    public double getReflexiveVariance() {
        int count = 0;
        double sum = 0.0;
        for (int i = 0; i < matrix.length; i++){
            for (int j = 0; j < matrix[i].length; j++){
                if (i != j){
                    count++;
                    sum += Math.abs(matrix[i][j] - matrix[j][i]);
                }
            }
        }
        return sum / count;
    }
    
    
    public double getNonReflexiveVariance() {
        int count = 0;
        double sum = 0.0;
        for (int k = 0; k < 1000; k++){
            int i1 = (int) (Math.random() * matrix.length);
            int j1 = (int) (Math.random() * matrix.length);
            int i2 = (int) (Math.random() * matrix.length);
            int j2 = (int) (Math.random() * matrix.length);
            if (i1 != j1 && i2 != j2 && (i1 != j2 || j1 != i2) && (i1 != i2 || j1 != j2)){
                count++;
                sum += Math.abs(matrix[i1][j1] - matrix[i2][j2]);
            }
        }
        return sum / count;
    }
    
    public double getMedianDistance(){
        double[] distances = new double[(matrix.length * matrix.length - matrix.length)];
        int k = 0;
        for (int i = 0; i < matrix.length; i++){
            for (int j = 0; j < matrix[i].length; j++){
                if (j != i){
                    distances[k] = matrix[i][j];
                    k++;
                }
            }
        }
        Arrays.sort(distances);
        double median = (distances[distances.length/2] + 
                  distances[distances.length/2 + 1]) / 2;
        return median;
    }
}
