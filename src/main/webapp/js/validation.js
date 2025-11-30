/**
 * Fichier de validation des formulaires
 * Valide les champs côté client avant soumission
 */

// Validation du nom et prénom (que des lettres, espaces, tirets, apostrophes)
function validerNomPrenom(valeur, champNom) {
    const regex = /^[a-zA-ZÀ-ÿ\s\-']+$/;
    if (!valeur || valeur.trim() === '') {
        return `Le ${champNom} est obligatoire.`;
    }
    if (!regex.test(valeur)) {
        return `Le ${champNom} ne peut contenir que des lettres, espaces, tirets et apostrophes.`;
    }
    if (valeur.length < 2) {
        return `Le ${champNom} doit contenir au moins 2 caractères.`;
    }
    if (valeur.length > 50) {
        return `Le ${champNom} ne peut pas dépasser 50 caractères.`;
    }
    return null;
}

// Validation de l'email
function validerEmail(email) {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if (!email || email.trim() === '') {
        return 'L\'email est obligatoire.';
    }
    if (!regex.test(email)) {
        return 'L\'email doit être au format valide (exemple@domaine.com).';
    }
    return null;
}

// Validation du matricule (format: EMP-XXXX)
function validerMatricule(matricule) {
    const regex = /^[A-Z0-9\-]+$/;
    if (!matricule || matricule.trim() === '') {
        return 'Le matricule est obligatoire.';
    }
    if (!regex.test(matricule)) {
        return 'Le matricule ne peut contenir que des lettres majuscules, chiffres et tirets.';
    }
    if (matricule.length < 3 || matricule.length > 20) {
        return 'Le matricule doit contenir entre 3 et 20 caractères.';
    }
    return null;
}

// Validation du téléphone
function validerTelephone(telephone) {
    const regex = /^[0-9\s\+\-\(\)]+$/;
    if (!telephone || telephone.trim() === '') {
        return null; // Téléphone optionnel
    }
    if (!regex.test(telephone)) {
        return 'Le téléphone ne peut contenir que des chiffres, espaces, +, -, ( et ).';
    }
    if (telephone.replace(/\D/g, '').length < 10) {
        return 'Le téléphone doit contenir au moins 10 chiffres.';
    }
    return null;
}

// Validation d'un nombre positif
function validerNombrePositif(valeur, champNom) {
    if (!valeur || valeur.trim() === '') {
        return `Le ${champNom} est obligatoire.`;
    }
    const nombre = parseFloat(valeur);
    if (isNaN(nombre)) {
        return `Le ${champNom} doit être un nombre valide.`;
    }
    if (nombre < 0) {
        return `Le ${champNom} ne peut pas être négatif.`;
    }
    return null;
}

// Validation du salaire
function validerSalaire(salaire) {
    const erreur = validerNombrePositif(salaire, 'salaire');
    if (erreur) return erreur;
    
    const montant = parseFloat(salaire);
    if (montant < 500) {
        return 'Le salaire doit être supérieur à 500€.';
    }
    if (montant > 1000000) {
        return 'Le salaire ne peut pas dépasser 1 000 000€.';
    }
    return null;
}

// Validation de la date
function validerDate(date, champNom) {
    if (!date || date.trim() === '') {
        return `La ${champNom} est obligatoire.`;
    }
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) {
        return `La ${champNom} n'est pas valide.`;
    }
    return null;
}

// Afficher un message d'erreur
function afficherErreur(inputElement, message) {
    // Supprimer l'ancien message d'erreur s'il existe
    const existingError = inputElement.parentElement.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    
    if (message) {
        // Créer et afficher le message d'erreur
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.style.color = '#ef4444';
        errorDiv.style.fontSize = '0.875rem';
        errorDiv.style.marginTop = '5px';
        errorDiv.textContent = '⚠️ ' + message;
        
        inputElement.parentElement.appendChild(errorDiv);
        inputElement.style.borderColor = '#ef4444';
        return false;
    } else {
        inputElement.style.borderColor = '#10b981';
        return true;
    }
}

// Validation du formulaire employé
function validerFormulaireEmploye(form) {
    let isValid = true;
    
    // Récupération des champs
    const nom = form.querySelector('[name="nom"]');
    const prenom = form.querySelector('[name="prenom"]');
    const email = form.querySelector('[name="email"]');
    const matricule = form.querySelector('[name="matricule"]');
    const telephone = form.querySelector('[name="telephone"]');
    const salaire = form.querySelector('[name="salaire"]');
    const dateEmbauche = form.querySelector('[name="dateEmbauche"]');
    
    // Validation nom
    if (nom) {
        const erreur = validerNomPrenom(nom.value, 'nom');
        if (!afficherErreur(nom, erreur)) isValid = false;
    }
    
    // Validation prénom
    if (prenom) {
        const erreur = validerNomPrenom(prenom.value, 'prénom');
        if (!afficherErreur(prenom, erreur)) isValid = false;
    }
    
    // Validation email
    if (email) {
        const erreur = validerEmail(email.value);
        if (!afficherErreur(email, erreur)) isValid = false;
    }
    
    // Validation matricule
    if (matricule) {
        const erreur = validerMatricule(matricule.value);
        if (!afficherErreur(matricule, erreur)) isValid = false;
    }
    
    // Validation téléphone
    if (telephone) {
        const erreur = validerTelephone(telephone.value);
        if (!afficherErreur(telephone, erreur)) isValid = false;
    }
    
    // Validation salaire
    if (salaire) {
        const erreur = validerSalaire(salaire.value);
        if (!afficherErreur(salaire, erreur)) isValid = false;
    }
    
    // Validation date embauche
    if (dateEmbauche) {
        const erreur = validerDate(dateEmbauche.value, 'date d\'embauche');
        if (!afficherErreur(dateEmbauche, erreur)) isValid = false;
    }
    
    return isValid;
}

// Validation du formulaire fiche de paie
function validerFormulaireFichePaie(form) {
    let isValid = true;
    
    const salaireBase = form.querySelector('[name="salaireDeBase"]');
    const primes = form.querySelector('[name="primes"]');
    const deductions = form.querySelector('[name="deductions"]');
    const heuresSupp = form.querySelector('[name="heuresSupp"]');
    const joursAbsence = form.querySelector('[name="joursAbsence"]');
    
    // Validation salaire de base
    if (salaireBase) {
        const erreur = validerSalaire(salaireBase.value);
        if (!afficherErreur(salaireBase, erreur)) isValid = false;
    }
    
    // Validation primes
    if (primes && primes.value) {
        const erreur = validerNombrePositif(primes.value, 'primes');
        if (!afficherErreur(primes, erreur)) isValid = false;
    }
    
    // Validation déductions
    if (deductions && deductions.value) {
        const erreur = validerNombrePositif(deductions.value, 'déductions');
        if (!afficherErreur(deductions, erreur)) isValid = false;
    }
    
    // Validation heures supplémentaires
    if (heuresSupp && heuresSupp.value) {
        const erreur = validerNombrePositif(heuresSupp.value, 'heures supplémentaires');
        if (!afficherErreur(heuresSupp, erreur)) isValid = false;
    }
    
    // Validation jours d'absence
    if (joursAbsence && joursAbsence.value) {
        const erreur = validerNombrePositif(joursAbsence.value, 'jours d\'absence');
        if (!afficherErreur(joursAbsence, erreur)) isValid = false;
        
        // Vérifier que le nombre de jours d'absence ne dépasse pas 31
        const jours = parseFloat(joursAbsence.value);
        if (jours > 31) {
            afficherErreur(joursAbsence, 'Le nombre de jours d\'absence ne peut pas dépasser 31.');
            isValid = false;
        }
    }
    
    return isValid;
}

// Validation en temps réel
function activerValidationTempsReel(form) {
    const inputs = form.querySelectorAll('input[required], input[type="email"], input[type="number"], input[type="text"]');
    
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            const name = this.name;
            const value = this.value;
            
            let erreur = null;
            
            switch(name) {
                case 'nom':
                case 'prenom':
                    erreur = validerNomPrenom(value, name);
                    break;
                case 'email':
                    erreur = validerEmail(value);
                    break;
                case 'matricule':
                    erreur = validerMatricule(value);
                    break;
                case 'telephone':
                    erreur = validerTelephone(value);
                    break;
                case 'salaire':
                case 'salaireDeBase':
                    erreur = validerSalaire(value);
                    break;
                case 'primes':
                case 'deductions':
                case 'heuresSupp':
                case 'joursAbsence':
                    if (value) erreur = validerNombrePositif(value, name);
                    break;
                case 'dateEmbauche':
                    erreur = validerDate(value, 'date');
                    break;
            }
            
            afficherErreur(this, erreur);
        });
    });
}