class FrogGame:
    def __init__(self, frogs_count):
        self.start_state = self.__generate_start_state(frogs_count)
        self.win_state = self.__generate_win_state(frogs_count)


    def __generate_start_state(self, num):
        return num * '>' + '_' + num * '<'
    

    def __generate_win_state(self, num):
        return num * '<' + '_' + num * '>'


    def __final(self, state):
        if state == self.win_state:
            return True
        else:
            return False


    def __generate_children(self, state):
        children = []
        free_space_index = state.index('_')
        # (frog offset accorfing to the free space, the direction of the frog)
        possible_moves = [(1, '<'), (2, '<'), (-1, '>'), (-2, '>')]

        for (offset, frog_type) in possible_moves:
            if self.__can_move(state, offset, frog_type):
                child = self.__move(state, free_space_index + offset, free_space_index)
                children.append(child)

        return children
    

    def __can_move(self, state, offset, frog_type): 
        free_space_index = state.index('_')
        if offset > 0:
            if free_space_index + offset < len(state) and state[free_space_index + offset] == frog_type:
                return True
        else:
            if free_space_index + offset >= 0 and state[free_space_index + offset] == frog_type:
                possible_move = self.__move(state, free_space_index + offset, free_space_index)
                return True

        return False


    def __move(self, state, frog_index, free_space_index):
        tmp = list(state)
        tmp[frog_index], tmp[free_space_index] = tmp[free_space_index], tmp[frog_index]
        return ''.join(tmp)
    

    def __dfs_rec(self, curr, path, paths):
            path.append(curr)
            if self.__final(curr):
                paths.append(path[:])
            
            children = self.__generate_children(curr)

            for child in children:
                self.__dfs_rec(child, path, paths)
            
            path.pop()


    def find_paths_from(self, start):
        paths = []
        self.__dfs_rec(start, [], paths)
        return paths


    def shortest_path(self, paths):
        return min(paths, key=lambda arr: len(arr))


number = input("Enter the number of frogs facing one way: ")

g = FrogGame(int(number))
paths = g.find_paths_from(g.start_state)

shortest_path = g.shortest_path(paths)

for i in shortest_path:
    print(i)