# CLUSTERING OF THE DATA ON THE UNIT HYPERSPHERE

In this repository I am comparing the most common algorithms for clustering data on the unit hypersphere.

The goal of this repository is to create R scripts that provide results of macro-recall and macro-precision of the clustering algorithms.

Finally, these results will be compared with a novel algorithm that will be introduced in my future paper that is based on the synchronization fenomena clustering.

For these comparations I am using famous datasets:

* Iris dataset
* Household dataset
* Winsconsin Breast Cancer dataset

Beside real life data, we will use data generated with vMF distribution.

Current algorithms:

<table>
<thead>
<th>Dataset</th>
<th>spkmeans</th>
<th>movMF</th>
</thead>
<tr>
<td>Iris</td>
<td>recall - 0.747; precision - 0.787</td>
<td></td>
</tr>
<tr>
<td>Household</td>
<td>recall - 0.825; precision - 0.847</td>
<td>recall - 0.925; precision - 0.935</td>
</tr>
<tr>
<td>Breast cancer</td>
<td>recall - 0.976; precision - 0.967</td>
<td>recall - 0.916; precision - 0.945</td>
</tr>
<tbody>
</tbody>
</table>

As for the generated data we have used vMF distribution. For the first simulation we have generated 100 data points on the unit sphere, belonging to two clusters (50/50). For the first cluster we have used mean direction of v=[1,0,0] and concentration parameter kappa = 15. For the second cluster we have used mean direction of kappa=[0,1,0] and kappa=15. Data belongs to S3 space because it is normalized to lie on a unit sphere.

<table>
<thead>
<th>Dataset</th>
<th>spkmeans</th>
<th>movMF</th>
</thead>
<tr>
<td>100vMF</td>
<td>recall - 0.74; precision - 0.742</td>
<td>recall - 0.56; precision - 0.77</td>
</tr>
<tr>
<td>50vMF</td>
<td>recall - 0.66; precision - 0.66</td>
<td></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
</tr>
<tbody>
</tbody>
</table>