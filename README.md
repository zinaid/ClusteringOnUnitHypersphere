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
<td>recall - 0.82; precision - 0.828</td>
<td></td>
</tr>
<tr>
<td>Household</td>
<td>recall - 0.875; precision - 0.9</td>
<td>recall - 0.925; precision - 0.935</td>
</tr>
<tr>
<td>Breast cancer</td>
<td>recall - 0.968; precision - 0.962</td>
<td>recall - 0.916; precision - 0.945</td>
</tr>
<tbody>
</tbody>
</table>