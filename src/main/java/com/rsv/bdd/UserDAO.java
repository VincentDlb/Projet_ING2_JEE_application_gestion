package com.rsv.bdd;

import com.rsv.model.User;
import com.rsv.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

/**
 * DAO pour gérer les utilisateurs
 */
public class UserDAO {

	/**
	 * Récupère un utilisateur par son username uniquement
	 */
	public User getUserByUsername(String username) {
	    Session session = HibernateUtil.getSessionFactory().openSession();
	    User user = null;
	    
	    try {
	        String hql = "FROM User u WHERE u.username = :username";
	        Query<User> query = session.createQuery(hql, User.class);
	        query.setParameter("username", username);
	        
	        List<User> results = query.list();
	        if (!results.isEmpty()) {
	            user = results.get(0);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }
	    
	    return user;
	}

    public User getUserById(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.get(User.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

  
    public User getUserByEmployeId(Integer employeId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM User WHERE employe.id = :employeId";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("employeId", employeId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public List<User> listerTous() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.createQuery("FROM User ORDER BY nomComplet", User.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    public boolean ajouterUser(User user) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}