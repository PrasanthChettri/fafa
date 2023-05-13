pragma solidity ^0.8.0;

contract ShortestPath {
    function BFS(
        uint256[][] memory adj,
        uint256 src,
        uint256 dest,
        uint256 v

    ) internal pure returns (uint) {
        bool[] memory visited = new bool[](v);
        for (uint256 i = 0; i < v; i++) {
            visited[i] = false;
        }

        visited[src] = true;

        uint256[] memory queue = new uint256[](v);
        uint256 front = 0;
        uint256 rear = 0;
        queue[rear++] = src;
        uint result = 0 ; 
        while (front != rear) {
            uint256 u = queue[front++];
            result ++ ; 
            for (uint256 i = 0; i < adj[u].length; i++) {
                if (!visited[adj[u][i]]) {
                    visited[adj[u][i]] = true;
                    queue[rear++] = adj[u][i];

                    if (adj[u][i] == dest) {
                        return result;
                    }
                }
            }
        }

        return 0;
    }
function getShortestPath() public pure returns (uint) {
    uint256[][] memory adj = new uint256[][](6);
    adj[0] = new uint256[](6);
    adj[0][0] = 0;
    adj[0][1] = 1;
    adj[0][2] = 1;
    adj[0][3] = 0;
    adj[0][4] = 0;
    adj[0][5] = 0;

    adj[1] = new uint256[](6);
    adj[1][0] = 1;
    adj[1][1] = 0;
    adj[1][2] = 0;
    adj[1][3] = 1;
    adj[1][4] = 1;
    adj[1][5] = 0;

    adj[2] = new uint256[](6);
    adj[2][0] = 1;
    adj[2][1] = 0;
    adj[2][2] = 0;
    adj[2][3] = 0;
    adj[2][4] = 0;
    adj[2][5] = 1;

    adj[3] = new uint256[](6);
    adj[3][0] = 0;
    adj[3][1] = 1;
    adj[3][2] = 0;
    adj[3][3] = 0;
    adj[3][4] = 1;
    adj[3][5] = 0;

    adj[4] = new uint256[](6);
    adj[4][0] = 0;
    adj[4][1] = 1;
    adj[4][2] = 0;
    adj[4][3] = 1;
    adj[4][4] = 0;
    adj[4][5] = 0;

    adj[5] = new uint256[](6);
    adj[5][0] = 0;
    adj[5][1] = 0;
    adj[5][2] = 1;
    adj[5][3] = 0;
    adj[5][4] = 0;
    adj[5][5] = 0;

    uint256 s = 0;
    uint256 dest = 5;
    uint256 v = 6;

    return BFS(adj, s, dest, v);
}


}
