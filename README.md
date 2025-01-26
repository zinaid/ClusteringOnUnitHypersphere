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
<td>recall - 0.966666666666667; precision - 0.96969696969697</td>
<td>recall - 0.953333333333333; precision - 0.95906432748538</td>
</tr>
<tr>
<td>Household</td>
<td>recall - 0.825; precision - 0.847</td>
<td>recall - 0.825; precision - 0.870</td>
</tr>
<tr>
<td>Breast cancer</td>
<td>recall - 0.704; precision - 0.694</td>
<td>recall - 0.710; precision - 0.734</td>
</tr>
<tbody>
</tbody>
</table>

As for the generated data we have used vMF distribution. For the first simulation we have generated 100 data points on the unit sphere, belonging to two clusters (50/50). For the first cluster we have used mean direction of v=[1,0,0] and concentration parameter kappa = 15. For the second cluster we have used mean direction of kappa=[0,1,0] and kappa=15. Data belongs to S3 space because it is normalized to lie on a unit sphere. For the second dataset we have generated 50 data points on the unit sphere, belonging to two clusters (25/25). For the first cluster we have used mean direction of v=[1,1,1] and kappa = 50. For the second cluster we have used mean direction of kappa=[-1,-1,-1] and kappa = 50. Data is normalized and lies of the unit sphere surface.

<table>
<thead>
<th>Dataset</th>
<th>spkmeans</th>
<th>movMF</th>
</thead>
<tr>
<td>100vMF</td>
<td>recall - 0.58; precision - 0.5821</td>
<td>recall - 0.58; precision - 0.648809523809524</td>
</tr>
<tr>
<td>50vMF</td>
<td>recall - 0.84; precision - 0.84</td>
<td>recall - 0.92; precision - 0.931</td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
</tr>
<tbody>
</tbody>
</table>