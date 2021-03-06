package org.diploma.personalaccess.service.impl;

import org.apache.log4j.Logger;
import org.diploma.personalaccess.entity.Position;
import org.diploma.personalaccess.entity.User;
import org.diploma.personalaccess.repository.FacultyRepository;
import org.diploma.personalaccess.repository.UserRepository;
import org.diploma.personalaccess.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;

/**
 * UserService internal implementation. Service retrieve user from
 * application database
 *
 * @author Maksim Patapenka
 */
@Service
@Transactional
public class UserServiceImpl implements UserDetailsService, UserService {

    /**
     * Logger Log4j
     */
    private static final Logger log = Logger.getLogger(UserServiceImpl.class);


    /**
     * User repository bean
     */
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FacultyRepository facultyRepository;


    /**
     * Load user from database by username with helps user repository
     *
     * @param username of user
     * @return UserDetails information (Spring Security bean)
     *
     * @throws UsernameNotFoundException
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            String msg = "User with username = '" + username + "' was not found!";
            log.warn(msg);
            throw new UsernameNotFoundException(msg);
        }
        return user;
    }

    @Override
    public User getUserById(long id) {
        return userRepository.findOne(id);
    }

    @Override
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Collection<User> getSubordinates(User user) {
        if (user.getForm().getPosition().getSubs().size() > 1) {
            Collection<User> allSubs = new ArrayList<>();

            for (Position pos : user.getForm().getPosition().getSubs()) {
                String posName = pos.getName().toLowerCase();
                if ("сотрудник".equals(posName)) {
                    allSubs.addAll(userRepository.findByPositionAndNullFaculty(pos.getId()));

                    if (log.isDebugEnabled()) {
                        log.debug("Subs with pos employee: ");
                        for (User sub : allSubs) {
                            log.debug(sub.getUsername());
                        }
                    }
                } else {
                    allSubs.addAll(userRepository.findByFormFacultyInAndFormPositionIn(facultyRepository.findAll(),
                            Collections.singletonList(pos)));

                    if (log.isDebugEnabled()) {
                        log.debug("Subs with other pos: ");
                        for (User sub : allSubs) {
                            log.debug(sub.getUsername());
                        }
                    }
                }
            }

            return allSubs;
        }

        if (user.getForm().getFaculty() != null) {
            return userRepository.findByFormFacultyInAndFormPositionIn(
                    Collections.singletonList(user.getForm().getFaculty()),
                    user.getForm().getPosition().getSubs());
        }

        return new ArrayList<>();
    }

    @Override
    public void addUser(User user) {
        userRepository.save(user);
    }

}
